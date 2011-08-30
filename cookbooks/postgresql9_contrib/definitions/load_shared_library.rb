define :load_shared_library, :db_name => nil, :library_name => nil do
  library_name = params[:library_name]
  db_name = params[:db_name]
  
  execute "Postgresql loading library #{library_name}" do
    command "psql -U postgres -d #{db_name} -c \"LOAD \'#{library_name}\'\";"
  end
end