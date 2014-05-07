#
# Cookbook Name:: magento_redis
# Recipe:: default
#
# 
redis_instance = node['utility_instances'].find { |instance| instance['name'] == 'redis' }
app_name = "magtest" 
key = 'put your encryption key here'

if ['solo', 'app', 'app_master'].include?(node[:instance_role])
    template "/data/#{app_name}/shared/config/local.xml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "local.xml.erb"
    variables({
      :app_name => app_name,
      :dbuser => node[:owner_name],
      :dbpass => node[:owner_pass],
      :dbhost => node[:db_host],
      :key => key,
      :hostname => redis_instance[:hostname]
    })

  end
  
end
