define :load_sql_file, :db_name => nil, :filename => nil do
  db_name = params[:db_name]
  filename = params[:filename]
  
  execute "Postgresql loading file #{filename} on database #{db_name}" do
    command "psql -U postgres -d #{db_name} -f #{filename}"
  end
end