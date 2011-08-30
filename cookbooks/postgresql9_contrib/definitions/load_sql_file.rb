define :load_sql_file, :db_name => nil, :filename => nil do
  filename = params[:filename]
  db_name = params[:db_name]
  
  execute "Postgresql loading file #{filename}" do
    command "psql -U postgres -d #{db_name} -f #{filename}"
  end
end