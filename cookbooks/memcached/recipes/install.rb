#
# Cookbook Name:: memcached
# Recipe:: install
#

if util?(node[:memcached_custom][:utility_instance_name]) || (app_server? && node[:memcached_custom][:install_on_app_servers])
  execute "memcached-restart" do
    command "/etc/init.d/memcached restart"
    action :nothing
  end

  template "/etc/conf.d/memcached" do
    owner 'root'
    group 'root'
    mode 0644
    source "memcached.erb"
    notifies :run, 'execute[memcached-restart]', :immediately
  end
end
