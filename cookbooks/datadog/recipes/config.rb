ey_cloud_report "datadog" do
 message "DataDog::Custom Config Start"
end

template '/root/.datadog-agent/agent/datadog.conf' do
  source 'datadog.conf.erb'
  owner 'root'
  group 'root'
  mode '640'
  variables({
    :hostname => node[:hostname],
    :role => node[:instance_role],
    :env_name => node[:environment][:name],
    :api_key => node.default[:datadog][:api_key],
  })
end

ey_cloud_report "datadog" do
 message "DataDog::Custom Config End"
end
