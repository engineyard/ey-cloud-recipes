#
# Cookbook Name:: magento
# Recipe:: default
#

if app_server?

  # determine the type of environment running and set the redis_host appropriately
  if solo?
    redis_host = "localhost"
  elsif !node[:utility_instance].nil?
    redis_host = node['utility_instances'].find { |instance| instance['name'] == 'redis' }[:hostname]
  elsif !node[:db_host].nil?
    redis_host = node[:db_host]
  else
    redis_host = ""
  end

  node[:magento_apps].each do |app|
    template "/data/#{app[:app_name]}/shared/config/local.xml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "local.xml.erb"
    variables({
        :app_name => app[:app_name],
        :dbuser => node[:owner_name],
        :dbpass => node[:owner_pass],
        :dbhost => node[:db_host],
        :key => app[:encryption_key],
        :redis_host => redis_host,
        :redis_session_store => app[:redis_session_store],
        :redis_page_caching => app[:redis_page_caching]
      })
    end
  end
end
