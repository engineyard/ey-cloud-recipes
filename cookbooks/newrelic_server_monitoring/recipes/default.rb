enable_package "app-admin/newrelic-sysmond" do
  version "#{node[:newrelic][:version]}"
end

package "app-admin/newrelic-sysmond" do
  action :install
  version "#{node[:newrelic][:version]}"
end

template "/etc/newrelic/nrsysmond.cfg" do
  source "nrsysmond.cfg.erb"
  owner 'root'
  group 'root'
  mode 0644
  backup 0
  variables(
    :key   => node[:newrelic][:license_key])
end

remote_file "/etc/monit.d/nrsysmond.monitrc" do
  owner "root"
  group "root"
  mode 0644
  backup 0
  source "nrsysmond.monitrc"
end

directory "/var/log/newrelic" do
  action :create
  recursive true
  owner 'root'
  group 'root'
end

execute "monit reload" do
  action :run
end
