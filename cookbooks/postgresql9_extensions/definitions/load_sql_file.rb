define :load_sql_file, :db_name => nil, :extname => nil, :minimum_version => nil do
  db_name = params[:db_name]
  extname = params[:extname]
  minimum_version = params[:minimum_version].to_f

  if ['solo','db_master'].include?(@node[:instance_role])
    Chef::Log.info "Loading to database #{db_name} extension #{extname} supported on versions higher than: #{minimum_version}. PG version installed is #{@node[:postgres_version]}"
    
    # we ensure a minimum version is set, the version selected is at least the minimum version
    if not minimum_version.nil? && @node[:postgres_version] >= minimum_version
      # now we ensure the install syntax is appropriate for this version
      if @node[:postgres_version] == 0.0
        # we skip this
      # elsif @node[:postgres_version].to_f >= [some future revision where syntax changes]
      elsif @node[:postgres_version] >= 9.1
        execute "Postgresql loading extension #{extname}" do
          command %Q(psql -U postgres -d #{db_name} -c 'CREATE EXTENSION IF NOT EXISTS "#{extname}";')
        end
      elsif @node[:postgres_version] >= 9.0
        execute "Postgresql loading contrib #{extname} on database #{db_name}" do
          command "psql -U postgres -d #{db_name} -f /usr/share/postgresql-9.0/contrib/#{extname}.sql"
        end
      end
    end
  end
end
