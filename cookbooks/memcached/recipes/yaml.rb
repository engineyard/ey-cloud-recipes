#
# Cookbook Name:: memcached
# Recipe:: yaml
#

memcached_instances = node[:engineyard][:environment][:instances].select { |i| i[:name] == node[:memcached_custom][:utility_instance_name] && i[:role] == "util" }

if node[:memcached_custom][:install_on_app_servers]
  memcached_instances.concat node[:engineyard][:environment][:instances].select { |i| i[:role] == "app_master" || i[:role] == "app" || i[:role] == "solo" }
end

if app_server? || util?
  node[:applications].each do |app_name,data|
    template "/data/#{app_name}/shared/config/memcached_custom.yml" do
      source "memcached.yml.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0744
      variables({
          :app_name => app_name,
          :memcached_instances => memcached_instances
      })
    end
  end
end
