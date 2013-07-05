define :load_shared_library, :db_name => nil, :library_name => nil, :supported_versions => nil do
  library_name = params[:library_name]
  db_name = params[:db_name]
  supported_versions = params[:supported_versions]

  if @node[:postgres_version] == "9.0" && supported_versions.include?("9.0")
    execute "Postgresql loading library #{library_name}" do
      command "psql -U postgres -d #{db_name} -c \"LOAD \'#{library_name}\'\";"
    end
  elsif @node[:postgres_version] == "9.1" && supported_versions.include?("9.1")
    execute "Postgresql loading library #{library_name}" do
      command "psql -U postgres -d #{db_name} -c \"LOAD \'#{library_name}\'\";"
    end
  elsif @node[:postgres_version] == "9.2" && supported_versions.include?("9.2")
    execute "Postgresql loading library #{library_name}" do
      command "psql -U postgres -d #{db_name} -c \"LOAD \'#{library_name}\'\";"
    end
  end
end
