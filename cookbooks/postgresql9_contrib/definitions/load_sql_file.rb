define :load_sql_file, :db_name => nil, :filename => nil, :username => "deploy" do
  db_name = params[:db_name]
  filename = params[:filename]
  userperms = params[:username]
  
  execute "Postgresql loading file #{filename} on database #{db_name}" do
    command "psql -U #{userperms} -d #{db_name} -f #{filename}"
    # Chef::Log.info "psql -U #{userperms} -d #{db_name} -f #{filename}"
  end
end