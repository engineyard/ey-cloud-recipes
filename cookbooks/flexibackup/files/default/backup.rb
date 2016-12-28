

gem 'fog-aws', '>= 0.3.0'
require 'fog/aws'
require 'fileutils'
require File.expand_path(__FILE__ + '/../flexparse')
require 'open4'



module Flexibackup
  module CLI
    extend self
    
    class Backup
      def initialize(file, args)
        parser = Flexibackup::CLI::Parser.new(file)
        @options = parser.run(args)
        process_action(@options[:action])
      end
    
      private  
      
      def process_action(action)
        case action
        when 'create'
          create_backup
        when 'restore'   
          restore
        when 'download'    
          download
        when 'list'
          list_files
        when 'upload'
          upload_files
        when 'retention'
          retention
        else
          raise "I don't know how to perform #{action}! Exiting."
        end
      end
      
    # Shared Methods
      def connect_s3
        puts "Making AWS connection..."
        @connection = Fog::Storage.new({
          :provider => 'AWS',
          :aws_access_key_id => @options[:aws_key],
          :aws_secret_access_key => @options[:aws_secret_key]
          })
        puts "Accessing bucket: '#{@options[:bucket]}'..."
        begin
          @aws_directory = @connection.directories.create(
            :key => @options[:bucket],
            :public => false
          )
        rescue Excon::Errors::Conflict
        rescue Excon::Errors::Forbidden
        rescue => e
          puts e
          puts e.inspect
          exit
        end
        
        # filter aws results
        set_prefix
        unless @prefix.nil? or @prefix == ''
          @aws_directory = @connection.directories.get(@options[:bucket], prefix: @prefix) 
        else
          @aws_directory = @connection.directories.get(@options[:bucket]) 
        end
      end
      
      def number_to_human_size(size)
        if size < 1024
          "#{size} bytes"
        elsif size < 1024.0 * 1024.0
          "%.01f KB" % (size / 1024.0)
        elsif size < 1024.0 * 1024.0 * 1024.0
          "%.01f MB" % (size / 1024.0 / 1024.0)
        else
          "%.01f GB" % (size / 1024.0 / 1024.0 / 1024.0)
        end
      end
      
      def debug(msg)
        puts "DEBUG: #{msg}" if @options[:verbose]
      end
      
      def get_objects
        objects = {}

        @aws_directory.files.each do |file|
          source = file.key.split('/')[0]
          next if !(@options[:source].nil? or @options[:source] == '') and source != @options[:source]
          db = file.key.split('/')[1]
          next if !@options[:database].nil? and db != @options[:database]
          type = file.key.split('/')[2]
          next if !@options[:typefilter].nil? and type != @options[:typefilter]
          datepart = file.key.split('/')[3]
          known_format = get_known_format(type, datepart)

          top_sym = (db.nil? and type.nil?) ? source : "#{source}.#{db}.#{type}"
          
          timestamp = Time.parse("#{datepart.split('_')[0]} #{datepart.split('_')[1].gsub('-', ':')}") unless datepart.nil? or datepart.split('_')[1].nil? or !known_format
          timestamp = file.last_modified if timestamp.nil?

          if objects[top_sym] and objects[top_sym][:objects] and objects[top_sym][:objects].key?(timestamp)
            objects[top_sym][:objects][timestamp][:files] << file.key
            objects[top_sym][:objects][timestamp][:size] = objects[top_sym][:objects][timestamp][:size] + file.content_length
          elsif objects.key?(top_sym)
            objects[top_sym][:objects].merge!(timestamp => { :size => file.content_length, :files => [file.key] })
            objects[top_sym][:newest] = timestamp if timestamp > objects[top_sym][:newest]
            objects[top_sym][:oldest] = timestamp if timestamp < objects[top_sym][:oldest]
          else
            objects.merge!({ top_sym => { :source => source, :database => db, :typefilter => type, :datepart => datepart, :newest => timestamp, :oldest => timestamp, :known_format => known_format, :objects => { timestamp => { :size => file.content_length, :files => [file.key] }}}})
          end

        end
        
        objects = objects.sort_by { |k, v| [v[:known_format] ? 0 : 1, v[:source], v[:database], v[:timestamp]] }

      end
      
      def gets_timeout( prompt, secs )
        print prompt + "[timeout=#{secs}secs]: "
        Timeout::timeout( secs ) { gets }
      rescue Timeout::Error
        puts "*timeout"
        ''  # return nil if timeout
      end
      
      def mysql_run(cmd)
        mysql = `which mysql`.chomp
        debug("Running command: mysql -NB -e '#{cmd}'")
        %x(#{mysql} -NB -e '#{cmd}' 2>/dev/null)
      end
      
      def set_prefix
        @prefix = ''
        @prefix = @options[:source] if @options[:source]
        @prefix = @prefix + "/#{@options[:database]}" if @options[:source] and @options[:database]
        @prefix = @prefix + "/#{@options[:typefilter]}" if @options[:source] and @options[:database] and @options[:typefilter]
        @prefix = @prefix + "/#{@options[:datefilter]}" if @options[:source] and @options[:database] and @options[:typefilter] and @options[:datefilter]
        debug('@prefix set as ' + @prefix)
      end
      
      def get_known_format(type, datepart)
        if datepart.nil? or  !(datepart =~ /(\d{4})-(\d{2})-(\d{2})/) or !['full', 'partial'].include?(type)
          false
        else
          true
        end
      end
      
    # Creation of Backups
    
      def run(command)
        raise "Failed to run backup command." unless runs?(command)
      end
    
      def runs?(command)
        
        command = command + " 2> /tmp/flexbackup.$$.dumperr"
        # This is to detect failures anywhere in the pipeline.
        wrapper = <<-EOT
          status=0
          set -o pipefail
          #{command}
          status=$?
          if [ $status -gt 0 ]; then exit 1; fi
        EOT
        
        debug "Running command: #{command}" 
        pid, *_ = Open4.popen4(wrapper)
        pid, status = Process::waitpid2(pid)
        
        if ! status.success?
          dumperr = File.read("/tmp/flexbackup.#{pid}.dumperr")
          debug("DB dump failed. The error returned was: #{dumperr}")
        end
        
        # Clean up:
        # This whole error output thing is hideous.
        # We need the errors, but as we're dealing with a pipeline we
        # need to capture them separately rather than send them as
        # input to the next process. We construct the backup command
        # in the backup engine but only know the pid of the resulting
        # backup here. Ugh.
        system("rm /tmp/flexbackup.#{pid}.dumperr") if File.exists?("/tmp/flexbackup.#{pid}.dumperr")
        
        status.success?
      end
      
      def create_backup
        backup_start=Time.now().strftime("%Y-%m-%d_%H-%M-%S")
        
        databases = @options[:database].nil? ? get_dbs : @options[:database].split
        databases.each do |db|
          set_backup_type
          @options[:filepath] = File.join(@options[:tempdir], "#{@options[:source]}/#{db}/#{@options[:typefilter]}/#{backup_start}")
          FileUtils.mkdir_p(@options[:filepath])
          FileUtils.chown('mysql', 'mysql', @options[:filepath])
          
          mysqldump = `which mysqldump`.chomp
          base_command = "#{mysqldump} --routines #{single_transaction_option(db)} #{@options[:myopts]}"
          
          # capture full structure for both backup types
          gpg_command = get_gpg('sql')
          backup_command = "#{base_command} --no-data #{db} |gzip #{gpg_command} > #{@options[:filepath]}/structure.full#{@extension}"
          puts "Backing up structure for database #{db}..."
          debug(backup_command)
          `#{backup_command}`
          
          if @options[:tab]
            gpg_command = get_gpg
            backup_command = "#{base_command} #{db} #{table_options} --tab=#{@options[:filepath]}"
            
            puts "Running Backup for database #{db}..."
            debug(backup_command)
            run(backup_command)
            #`#{backup_command}`
            
            
            # change to the working directory to exclude paths from archive
            origin_pwd = Dir.pwd
            Dir.chdir(@options[:filepath])

         
            # For each table create a tar.gz Archive
            create_archive_files(gpg_command)

            Dir.chdir(origin_pwd)
            
          else
            gpg_command = get_gpg('sql')
            backup_command = "#{base_command} #{db} #{table_options} |gzip #{gpg_command} > #{@options[:filepath]}/#{db}#{@extension}"
            
            puts "Running Backup for database #{db}..."
            debug(backup_command)
            `#{backup_command}`
          end

          

          # For each tar.gz archive upload to AWS S3
          res=process_action('upload')
          unless res
            puts "\n\n****Error**** failed to upload to S3. Maintaining local copy of backup."
            # ****** This should generate an alert!
          else
            puts "Upload successful!"
            FileUtils.rm_rf @options[:filepath]
            # ******* This should generate a successful backup notice.
          end

          puts "Backup for #{db} successfully completed at #{Time.now()}" 
          retention
        end 
      end
      
      def get_dbs
        ignore_dbs = ['information_schema', 'mysql', 'performance_schema', 'engineyard', 'test']
        all_databases = mysql_run('show databases').split("\n")
        all_databases - ignore_dbs
      end
      
      def single_transaction_option(db)
        test = mysql_run("select 1 from information_schema.tables where table_schema='#{db}' and engine='MyISAM' limit 1").chomp
        test != '1' ? '--single_transaction' : ''
      end
      
      def get_gpg(type = 'tar')
        @extension = @options[:gpgkey].nil? ? ".#{type}.gz" : ".#{type}.gz.gpg"
        @options[:gpgkey].nil? ? '' : "| gpg --encrypt --recipient #{@options[:gpgkey]}"
      end
      
      def table_options
        @options[:tables].nil? ? '' : @options[:tables].gsub(',',' ')
      end
      
      def set_backup_type
        @options[:typefilter] = @options[:tables].nil? ? 'full' : 'partial'
      end
      
      def create_archive_files(gpg_cmd)
        puts "Generating compressed archive(s)"
        ext = '.sql'
        Dir["./*#{ext}"].each do |file|
          basefile = File.basename(file, ext)

          debug("tar -zc #{basefile}.* #{gpg_cmd} > #{basefile}#{@extension}")
          `tar --exclude='*.gpg' -zc #{basefile}.* #{gpg_cmd} > #{basefile}#{@extension}`
          File.delete("#{basefile}#{ext}")
          File.delete("#{basefile}.txt") if File.exist?("#{basefile}.txt")
        end
      end
      
      
    # S3 Uploads
      def upload_files
        begin
          # verify valid path
          raise "Bad File Path #{@options[:filepath]}" unless File.exist?(@options[:filepath])
      
          upload_root = @options[:filepath].gsub(@options[:tempdir], '')
          files = File.directory?(@options[:filepath]) ? dir_files(@options[:filepath]) : @options[:filepath].split
      
          connect_s3
      
          files.each do |file|
            s3name = "#{upload_root}/#{File.basename(file)}"
            debug("uploading #{file} in bucket #{@options[:bucket]} as #{s3name}")
            file = @aws_directory.files.create(
              :key => "#{s3name}",
              :body => File.open(file),
              :public => false,
              :multipart_chunk_size => 10*1024*1024, # 10MB
              'x-amz-server-side-encryption' => 'AES256'
            )
          end
      
        rescue => e
          puts e
          return false
        end
      end
      
      def dir_files(dir)
        Dir["#{dir}/**/*"].reject{ |fn| File.directory?(fn) }
      end
      
    # Listing of backups
      def list_files
        connect_s3
        objects = get_objects    
        print_bucket_contents(objects)
      end
  
      def print_bucket_contents(objects)
        count=0
        unknown=0
        objects.each do |k, v|
          puts "Backups in a recognized format:" if v[:known_format] and count==0
          if v[:known_format]
            puts "  Source: #{v[:source]}"
            puts "    Database: #{v[:database]}"
            puts "    Type: #{v[:typefilter]}"
            puts "    Oldest: #{v[:oldest]}"
            puts "    Newest: #{v[:newest]}"
            puts "    Backups:"
            count = 0
            ordered_keys(v[:objects]).each do |objk|
              puts "      #{count+=1} - Date: #{objk}; Size: #{number_to_human_size(v[:objects][objk][:size])} bytes; File count: #{v[:objects][objk][:files].count}"
            end
          else
            if unknown == 0
              puts "\nBackups in an unrecognized format:"
              unknown +=1
            end
             puts "  Source Dir: #{k}"
             count = 0
             ordered_keys(v[:objects]).each do |objk|
               puts "    #{count+=1} - Date: #{objk}; Size: #{number_to_human_size(v[:objects][objk][:size])} bytes; File: #{ v[:objects][objk][:files]}"
             end
          end

        end
      end
      
      def ordered_keys(object)
        object.keys.sort.reverse
      end
      
    # Backup downloads from S3
      def download
        connect_s3
        objects = get_objects

        sources = get_uniques(:source, objects)
        abort "No objects found for those parameters" if sources.length == 0
        this_source = get_source(sources)
        if this_source != @options[:source]
          @options[:source] = this_source
          objects = refine_objects(objects, :source)
        end

        dbs = get_uniques(:database, objects)
        this_db = get_db(dbs)

        if this_db != @options[:database]
          @options[:database] = this_db
          objects = refine_objects(objects, :database)
        end
        
        types = get_uniques(:typefilter, objects)
        types = types.select { |t| ['full', 'partial'].include?(t) }
        this_type = get_type(types)
        if this_type != @options[:typefilter]
          @options[:typefilter] = this_type
          objects = refine_objects(objects, :typefilter)
        end

        # Prompt for index if not set  
        @options[:index] = get_index(objects) unless @options[:index]

        files = get_files_from_index(objects)

        if files.length < 1
          puts "Failed to find any files in S3 at for Source: #{this_source}, DB: #{this_db}, Index: #{@options[:index]}; this is probably a bug that should be reported."
          exit 1
        end

        # download to working directory
        s3_path = files[0].split('/')[0..-2].join('/')
        @options[:restore_path] = "#{@options[:tempdir]}#{s3_path}/"
        FileUtils.mkdir_p(@options[:restore_path])
        files.each do |file|
          next unless @options[:tables].nil? or @options[:tables].include?(File.basename(file).split('.')[0]) or File.basename(file).split('.')[0..1].join('.') == 'structure.full'
          debug("Downloading: #{file}")
          remote_file = @aws_directory.files.get(file)
          File.open("#{@options[:tempdir]}/#{file}", "w") do |local_file|
            local_file.write(remote_file.body)
          end
        end
        FileUtils.chown_R('mysql', 'mysql', @options[:restore_path])
        puts "Downloads completed to: #{@options[:restore_path]}"
      end
      
      def get_files_from_index(objects)
        @options[:index].downcase!

        if %w{oldest newest}.include? @options[:index]
          key = objects[@options[:index].to_sym]
          return objects[:objects][key][:files]
        else
          count = 0
          objects.each do |k, v|
            ordered_keys(v[:objects]).each do |objk|
              count+=1
              return v[:objects][objk][:files] if count == @options[:index].to_i
            end
          end
        end
      end
      
      def get_uniques(type, objects)
        objects.map { |k, v| v[type] }.uniq
      end
      
      def get_source(sources)
        return sources.join if sources.length == 1
        prompt = "Select the Source of your backup:"
        puts
        sources.each_with_index do |source, index| 
          puts "  #{index + 1} - '#{source}'"
        end
        sources[select_from_array(sources, prompt) - 1]
      end

      def get_db(dbs)
        return dbs.join if dbs.length == 1
        prompt =  "Select the database to download:"
        puts
        dbs.each_with_index do |db, index| 
          puts "  #{index + 1} - '#{db}'"
        end
        dbs[select_from_array(dbs, prompt) - 1]
      end
      
      def get_type(types)
        return types.join if types.length == 1
        prompt = "Select the type of backup to download:"
        types.each_with_index do |type, index|
          puts "  #{index + 1} - '#{type}'"
        end
        types[select_from_array(types, prompt) - 1]
      end
      
      def select_from_array(this_array, prompt)
        begin
          input = gets_timeout(prompt, 30).chomp.to_i
          raise "Invalid input #{input}" if input < 1 or input > this_array.length
        rescue => e
          puts "#{e}"
          exit 1
        end
        input
      end

      def get_index(objects)
        prompt = "Select the index of the backup to download:"
        puts
        print_bucket_contents(objects)

        gets_timeout(prompt, 30).chomp  
      end
      
      def refine_objects(objects, by)
        objects.select do |k, v|
          v[by] == @options[by]
        end
      end
      
    # Database restores
      def restore
        if @options[:restore_path]
          puts "**WARNING** Table options ignored when using --restore_path." if @options[:tables]
        else
          # call flexis3.rb with download options, capture output directory
          puts "Downloading your backup..."
          process_action('download')
        end
        
        # prompt if batch function not set
        unless @options[:batch]
          prompt = "This operation will overwrite the data in the database #{@options[:target_db]} on this host; are you sure you want to proceed (Y/n)?"
          abort("exiting...") unless gets_timeout(prompt, 30).chomp.downcase == 'y'
        end
        
        # decrypt the backups if necessary/possible
        decrypt_file
        
        # recreate the database if necessary
        set_or_reset_db
        
        structure_restored = false
        structure_restored = load_structure if @options[:load_structure]
        
        # restore data files, remove the .sql files, restore the tab files
        load_data_and_structure(structure_restored)
        
        # cleanup the source directory
        unless @options[:batch]
          prompt = "Cleanup restoration directory '#{@options[:restore_path]}/' (Y/n)?"
          abort("exiting...") unless gets_timeout(prompt, 30).chomp.downcase == 'y'
        end
        FileUtils.rm_rf(@options[:restore_path])
        puts "Cleanup complete!"
      end
      
      def decrypt_file
        origin_pwd = Dir.pwd
        Dir.chdir(@options[:restore_path])
        gpg_files = Dir['./*.gpg']
        if gpg_files.count > 0
          puts "Make sure you have imported the GPG secret key and then enter the Passphrase needed to decrypt this backup:"
          passphrase = gets.chomp
          puts "Decrypting files..."
          gpg_files.each do |gpg_file|
            file = File.basename(gpg_file, '.gpg')
            `gpg --passphrase #{passphrase} --batch -d --output #{file} #{gpg_file}`
            FileUtils.rm(gpg_file)
          end
          puts "done!"
        end
        Dir.chdir(origin_pwd)
      end
      
      def create_db(db)
        create_cmd="Create database if not exists #{db}"
        %x(mysql -e '#{create_cmd}')
      end
      
      def set_or_reset_db
        db = @options[:target_db]
        if @options[:clean] or @options[:load_structure]
          puts "Resetting database '#{db}'..."
      
          query = "show create database #{db} \\G"
          create_cmd = mysql_run(query).split("\n").last
          create_cmd="Create database #{db}" if create_cmd.nil? or create_cmd==""
          mysql_run("DROP DATABASE IF EXISTS #{db}")
          mysql_run(create_cmd)
      
          puts "done!"
        else
          create_cmd="Create database if not exists #{db}"
          mysql_run(create_cmd)
        end
      end
      
      def load_structure
        restored = false
        origin_pwd = Dir.pwd
        Dir.chdir(@options[:restore_path])
        FileUtils.mkdir_p('./restored')
        structure_file = Dir['./structure.full.sql.gz']
        if structure_file.count == 0
          puts "**WARNING**: Cannot load structure file #{@options[:restore_path]}/structure.full.sql.gz does not exist."
        else
          structure_file = structure_file[0]
          gz_load_sql(structure_file)
          `mv #{structure_file} ./restored/`
          restored = true
        end
        Dir.chdir(origin_pwd)
        restored
      end
      
      def load_data_and_structure(structure_restored)
        origin_pwd = Dir.pwd
        Dir.chdir(@options[:restore_path])
        FileUtils.mkdir_p('./restored')
        archives = Dir['./*.tar.gz']
        if archives.count > 0
          archives.each do |archive|
            extract_archive(archive)
          end
          sql_files = Dir['./*.sql']
          data_files = Dir['./*.txt']
          sql_files.each do |sql_file|
            if structure_restored
              FileUtils.rm(sql_file)
            else
              load_sql(sql_file)
              `mv #{sql_file} ./restored/`
            end
          end
          data_files.each do |data_file|
            full_path = Dir.pwd + '/' + data_file
            load_data(full_path)
            `mv #{data_file} ./restored/`
          end
        else
          sql_gz_files = Dir['./*.sql.gz']
          unless sql_gz_files.length == 1 or sql_gz_files.length == 2
            puts "**WARNING**: Cannot find a valid backup at #{@options[:restore_path]}."
          else
            sql_gz_files.each do |sql_gz_file|
              unless sql_gz_file == './structure.full.sql.gz'
                gz_load_sql(sql_gz_file)
                restored = true
              end
              `mv #{sql_gz_file} ./restored/`
            end
          end
        end
        Dir.chdir(origin_pwd)
      end
      
      def load_sql(file)
        %x(mysql #{@options[:target_db]} < #{file})
      end
      
      def gz_load_sql(file)
        debug("loading file #{file}")
        %x(gunzip -f < #{file} | mysql #{@options[:target_db]})
      end

      def load_data(file)
        %x(mysqlimport #{@options[:target_db]} #{file})
      end
      
      def extract_archive(archive)
        `tar -xvf #{archive} && mv #{archive} ./restored/`
      end
      
    # S3 File Retention
      ## retention only runs after an upload so fog will still be connected
      def retention
        if @options[:retention] == 0
          puts "Notice: retention management disabled with :retention value of '0'."    
        else
          connect_s3
          object = get_objects.first
          removals = ordered_keys(object[1][:objects])[@options[:retention]..-1]
          removals.each do |key|
            remove_files_for_key(object[1], key)
          end unless removals.nil?
        end
      end
      
      def remove_files_for_key(object, key)
        files_to_remove = object[:objects][key][:files]
        debug("Removing files based on retention of '#{@options[:retention]}. File list:\n #{files_to_remove}")
        # add the container to the list of items to remove
        files_to_remove << object[:objects][key][:files].first.split("/")[0]
        @connection.delete_multiple_objects(@options[:bucket], files_to_remove)
      end
    
    end
  end
end
