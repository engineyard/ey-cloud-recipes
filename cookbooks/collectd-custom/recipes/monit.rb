#
# Cookbook Name:: collectd-custom
# Recipe:: monit
#
# Installs a monitrc file to ensure collectd stays running (optional)
#

attributes = node['collectd-custom']

template "/etc/monit.d/#{attributes['service_name']}.monitrc" do
  owner 'root'
  group 'root'
  mode 0644
  source "collectd.monitrc.erb"
  variables({
    :pid_file => attributes['pid_file'],
    :service_name => attributes['service_name']
  })
  notifies :reload, "service[monit]"
end
