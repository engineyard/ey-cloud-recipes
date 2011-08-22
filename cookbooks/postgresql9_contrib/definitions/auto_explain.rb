define :postgresql9_autoexplain do
  dbname_to_use = params[:name]
  # Chef::Log.info "db: #{dbname_to_use}"
  # Chef::Log.info "cmd: psql -U postgres -d #{dbname_to_use} -c \"LOAD 'auto_explain'\";"
  
  execute "enable chpass on db" do
    command "psql -U postgres -d #{dbname_to_use} -c \"LOAD \'auto_explain\'\"; "
  end
  
  include_recipe "postgresql9_contrib::ext_autoexplain"

end


