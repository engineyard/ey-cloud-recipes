#
# Cookbook Name:: collectd-custom
# Recipe:: simplercpu
#
# Setup config to aggregate CPU
#

template "/data/collectd.d/simpler-cpu.conf" do
  owner node['collectd-custom']['user']
  group node['collectd-custom']['user']
  mode 0644
  source "simpler_cpu.conf.erb"
  notifies :restart, "service[#{node['collectd-custom']['service_name']}]"
end
