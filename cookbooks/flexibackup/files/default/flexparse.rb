require 'optparse'
require 'yaml'

module Flexibackup
  module CLI
    extend self
    
    class Parser
      def initialize(thisfile)
        file = File.basename(thisfile)
        dir = File.dirname(thisfile)
        @path_local = "#{dir}/config/#{file.split('.')[0]}_config.yml"
        @path_etc = "/etc/#{file.split('.')[0]}_config.yml"
        @default_options = { :retention => 31 }
        @tempbase = determine_tmp
        @tempdir = @tempbase + '/#{action}'
        @this_file = file
        @tab_position = "\t\t\t\t     "
      end
      
      def run(argv)
        
        options = opt_parse(argv)      
        
        config_path = options[:config] 
        config_path = File.exist?(@path_local) ? @path_local : @path_etc if config_path.nil?
        set_tempdir(options[:action])
     
        options.merge!(config_for(config_path)) {|key, oldval, newval| oldval.nil? ? newval : oldval} 

        # set target_db if not set
        options[:target_db] = options[:database] if options[:target_db].nil?
        options = @default_options.merge(options)
        
        check_type_filter(options) if options[:action] == 'create'
        extra_validations(options)
        options
      end
      
      def config_for(config_path)
        config_opts = {}
        
        config_opts=YAML::load(File.read(config_path)) if File.exist?(config_path)
        config_opts = config_opts.each_with_object({}) {|(k,v),memo| memo[k.to_sym] = v}
        config_opts[:tempdir] = @tempdir if config_opts[:tempdir].nil?

        config_opts
      end
      
      def extra_validations(options)
        begin
          mandatory = [:action, :tempdir, :retention]
          mandatory = mandatory + [:filepath] if options[:action] == "upload"
          mandatory = mandatory + [:source] if options[:action] == "create"
          mandatory = mandatory + [:bucket] unless options[:action] == "restore" and ! options[:restore_path].nil?

          mandatory = mandatory + [:target_db] if options[:action] == 'restore'
          
          raise OptionParser::InvalidArgument, "For --restore_path of #{options[:restore_path]}" if !options[:restore_path].nil? and Dir["#{options[:restore_path]}/*"].empty?
          missing = mandatory.select{ |param| options[param].nil? }
          raise OptionParser::MissingArgument, missing.join(', ') unless missing.empty?
        rescue OptionParser::ParseError => e
          puts '*'*50
          puts "* #{e}"
          puts '* Try `./flexis3.rb -a list -s ""` to obtain source, database, and index' unless (%w(database index source) & e.message.split).empty?
          puts '*'*50
          puts "\n"
          puts @optparse
          exit 1
        end
      end
      
      def check_type_filter(options)
        puts 'WARNING: option --typefilter ignored for --action create' unless options[:typefilter].nil?
      end
    
      def determine_tmp
        File.writable?('/mnt/tmp') ? '/mnt/tmp/' : './mnt/tmp/'
      end
      
      def set_tempdir(action)
        case action
        when "download", "restore"
          @tempdir = @tempbase + 'download/'
        when "create"
          @tempdir = @tempbase + 'backup/'
        end
      end
      
      def opt_parse(argv)
        options = {}
        
        @optparse = OptionParser.new do |opts|
          opts.banner = "Usage: #{@this_file} [options]"
          opts.separator "Tool for creation, download, or restoration of database backups that allows for a tab delimited backup option as well as the exclusion of specific tables."
          opts.separator 'Options specified on the command line supercede options supplied in a configuration file.'
      
          # These options can be specified in the config file or on the command line
          opts.separator ''
          opts.separator 'Command line options'
          # These options are command line only
          actions = ['create', 'download', 'list', 'restore', 'upload']
      
          opts.on('-a', '--action action', "Controls what operation will be performed #{actions}") do |action|
            unless actions.include?(action)
              puts "Invalid action: '#{action}' must be one of #{actions}\n\n" 
              puts opts
              exit 1
            end
            
            options[:action] = action
          end
          
          opts.on('-d', '--database dbname', "Name of the database to be acted on.","For create, the db to backup; for restore, the db to download for (see --target_db for redirecting restore).") do |dbname|
            options[:database] = dbname
          end
          
          opts.on('-t', '--tables t1,t2,t3', "Names of the tables to be processed.") do |tables|
            options[:tables] = tables
          end
      
          opts.on('-c', '--config config_file', "Allows specification of a custom configuration file; only a single configuration file will be read.",
        "Precendence:",
        "  * command options",
        "  * file specified as command option via -c or --config options",
        "  * named #{@path_local}",
        "  * finally #{@path_etc}") do |config|
            options[:config] = config
          end
          
          opts.on('-i', '--index backup_index', "Index number of the backup to act upon (effective only for download and restore),",
          "accepts 'recent' to reference the most recent available backup.") do |index|
            if %(newest oldest).include?(index.downcase) or index.to_i > 0
              options[:index] = index
            else
              puts "Invalid index: '#{index}', must be an number matching one of the available backups given by `--action list` or the strings 'oldest' or 'newest'"
            end
          end
          types = ['full', 'partial']
          opts.on('--typefilter typefilter', 'Type filter limits the files read from s3 when searching for backups to \'full\' or \'partial\' types (download, restore, or list)',
          'Only useful when source, and database name is set.') do |typefilter|
            unless types.include?(typefilter)
              puts "Invalid type: '#{typefilter}' must be one of #{types}\n\n" 
              puts opts
              exit 1
            end
            options[:typefilter] = typefilter
          end
          opts.on('--datefilter datefilter', 'Date filter control to limit files read from s3, specify in increasing granularity (eg. "2016" or "2016-10")',
          'Only useful when source, database name, and type (full vs partial) is set.',
          'Typically you only want to include year or year and month.') do |datefilter|
            options[:datefilter] = datefilter
          end
          
          
          opts.on('-v', '--verbose', "Displays more verbose messaging (DEBUG mode).") do
            options[:verbose] = true
          end
      
          opts.on('-h', '--help', 'Displays Help') do
            puts opts
            exit
          end
          
          
          opts.separator ''
          opts.separator 'Storage specific options:'
          opts.on('-u', '--aws_key key', "AWS S3 Key") { |key| options[:aws_key] = key }
          opts.on('-p', '--aws_secret_key secret', 'AWS S3 Secret Key') { |secret| options[:aws_secret_key] = secret }
          opts.on('-b', '--bucket bucket', 'AWS S3 bucket identifier (recommended: name by region)') { |bucket| options[:bucket] = bucket }
          opts.on('-s', '--source source_name', "Uniquely identifies source of a given backup (e.g. environment_name).",
          "Use \`-s ''\` to override source from config file with flexis3 to show full bucket contents.") { |source| options[:source] = source }          
          
          
          opts.separator ''
          opts.separator 'Create specific options:'
          opts.on('-g', '--gpgkey gpg_keyname', 'GPG Encryption key identifier (create only)') { |gpgkey| options[:gpgkey] = gpgkey }
          opts.on('--tab', 'Use tab-delimited files. For action=create only (create only)') { options[:tab] = true }
          opts.on('-o', '--options addl_options', 'Raw options to pass through to `mysqldump` command *Warning* some options may not function (create only)') do |myopts|
            options[:myopts] = myopts
          end
          
          opts.separator ''
          opts.separator 'Upload specific options:'
          opts.on('-f', '--file filepath', "Sets the path for files to be uploaded to S3. Recursive upload when its a directory.",
        "The containing directory will be the path within the bucket",
        "  * /local/my_dir/my_backup.sql.gz uploads as \#{bucket}/my_dir/my_backup.sql.gz)") do |filepath|
            options[:filepath] = filepath
          end
          
          opts.separator ''          
          opts.separator "Restore specific options:"
          opts.on('--clean', 'Forces drop/create of target database if exists.') do
            options[:clean] = true
          end
          opts.on('--load_structure', 'Reload the structure from the structure.full file if this is a tab-delimited backup (no affect on standard backup)','**WARNING** drops/recreates the target database.') do
            options[:load_structure] = true
          end
          opts.on('--target_db target_db', 'Restore data to target_db instead of to the named db.') do |target_db|
            options[:target_db] = target_db
          end
          opts.on('--restore_path restore_path', 'Path to backups that have already been downloaded (requires --target_db).') do |restore_path|
            options[:restore_path] = restore_path
          end
          opts.on('-b', '--batch', "Batch mode, skip all confirmation prompts for database restore operations (GPG backups still prompt).") do
            options[:force] = true
          end
          
          opts.separator ''
          opts.separator "Config file options
\taws_key: AWS S3 Key.
\taws_secret_key: AWS S3 Secret Key.
\tbucket: AWS S3 bucket identifier.
\tgpgkey: GPG Encryption key identifier.
\tmyopts: Additional options for mysqldump.

Config file only:
\ttempdir: temporary directory for processing files locally (default: /mnt/tmp/download [restore/download] or /mnt/tmp/backup [create])
\tretention: number of days of backups to keep in S3; 0 disables (default: #{@default_options[:retention]})"
      
          opts.separator ''
        end
        @optparse.parse!
      
        options
      end
      
    end
    
  end
end