dbtype = node[:engineyard][:environment][:db_stack_name]

if ['app', 'app_master', 'util', 'solo'].include?(node[:instance_role])
  node[:engineyard][:environment][:apps].each do |app|
    Chef::Log.info "--- Dropping db.yml file for db #{dbtype}"
  
    # check if we need to add the determine_adapter erb to template
    if !!(dbtype[/^mysql/] && app['type'][/^ra(ck|ils[34])$/])
      determine_adapter_code = <<-RUBY
<%
def determine_adapter
  if Gem.loaded_specs.key?("mysql2")
    "mysql2"
  else
    "mysql"
  end
rescue
  "#{dbtype}"
end
%>
      RUBY
      dbtype = '<%= determine_adapter %>'
    end
  
    template "/data/#{app[:name]}/shared/config/database.yml" do
      owner node['ssh_username']
      group node['ssh_username']
      mode 0600
      source "database.yml.erb"
      variables({
        :determine_adapter_code => determine_adapter_code,
        :environment => node[:environment][:framework_env],
        :dbuser => node['users'].first['username'],
        :dbpass => node['users'].first['password'],
        :dbname => app[:database_name],
        :dbhost => node['db_host'],
        :dbtype => dbtype,
        :slaves => node[:engineyard][:environment][:instances].select{|i| i["role"] =="db_slave"}
      })
    end
    
    execute "create keep.database.yml" do
      command "touch /data/#{app[:name]}/shared/config/keep.database.yml"
    end
  end
end