#
# Cookbook Name:: magento
# Recipe:: default
#

if app_server?
  redis_host = solo? ? "localhost" : node['utility_instances'].find { |instance| instance['name'] == 'redis' }[:hostname]
  
  node[:applications].each do |app_name, data|
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
        :key => node[:magento][:encryption_key],
        :redis_host => redis_host,
        :redis_session_store => node[:magento][:redis_session_store],
        :redis_page_caching => node[:magento][:redis_page_caching]
      })
    end
  end
end
