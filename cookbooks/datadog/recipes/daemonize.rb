#
# wrapper script will you need to dameonize the script the use to start the

ey_cloud_report "datadog" do
 message "DataDog::Daemonize Start"
end

cookbook_file "copy in the wrapper script" do
	path "#{node['wrapper']['directory']}/datadog_wrapper.sh"
  source "datadog_wrapper.sh"
  owner "root"
  group "root"
  mode "744"
  not_if "test -f #{node['wrapper']['directory']}/datadog_wrapper.sh"
end

link "dd-link" do
  owner "root"
  target_file "/bin/datadog_wrapper"
	to "#{node['wrapper']['directory']}/datadog_wrapper.sh"
end

execute 'monit-reload' do
  command 'monit reload'
  action :nothing
end

cookbook_file "copy in the datadog monit" do
	path "#{node['monit']['directory']}/datadog.monitrc"
  source "datadog.monitrc"
  owner "root"
  group "root"
  mode "644"
	not_if "test -f #{node['monit']['directory']}/datadog.monitrc"
  notifies :run, 'execute[monit-reload]', :immediately
end



ey_cloud_report "datadog" do
  message "DataDog::Daemonize End"
end
