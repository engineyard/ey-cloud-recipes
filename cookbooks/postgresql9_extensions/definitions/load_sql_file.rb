define :load_sql_file, :db_name => nil, :extname => nil, :supported_versions => nil do
  db_name = params[:db_name]
  extname = params[:extname]
  supported_versions = params[:supported_versions]
  
  Chef::Log.info "Loading to database #{db_name} extension #{extname} supported on versions: (#{supported_versions}). PG version installed is #{@node[:postgres_version]}"
  
  if @node[:postgres_version] == "9.0" && supported_versions.include?("9.0")
    execute "Postgresql loading contrib #{extname} on database #{db_name}" do
      command "psql -U postgres -d #{db_name} -f /usr/share/postgresql-9.0/contrib/#{extname}.sql"
    end
  elsif @node[:postgres_version] == "9.1" && supported_versions.include?("9.1")
      execute "Postgresql loading extension #{extname}" do
        command "psql -U postgres -d #{db_name} -c \"CREATE EXTENSION IF NOT EXISTS #{extname}\";"
      end
  end
  
end
