#
#oh you thought you could emerge this on gentoo....nope welcome
#

ey_cloud_report "datadog" do
 message "DataDog::Install Start"
end

directory '/home/deploy/datadog' do
  owner 'deploy'
  group 'deploy'
  mode 0755
  action :create
end

cookbook_file 'copy in setup script' do
  path '/home/deploy/datadog/setup_agent.sh'
  source 'setup_agent.sh'
  owner 'deploy'
  group 'deploy'
  mode '744'
  not_if { File.exists?( '/home/deploy/datadog/setup_agent.sh')  }
end

bash 'run the setup script' do
 user 'deploy'
 cwd '/home/deploy/datadog'
 code <<-EOH
  DD_API_KEY=#{node['datadog']['api_key']} sh ./setup_agent.sh
  EOH
 notifies :run, 'execute[rm-setup-tools]', :immediately
 not_if "test -f /home/deploy/datadog/.datadog-agent/bin/agent"
end

execute 'rm-setup-tools' do
  command "find /home/deploy/datadog -name 'setuptools-*.zip' | xargs rm"
  action :nothing
   only_if { !Dir.glob('/home/deploy/datadog/setuptools*.zip').empty? }
end

ey_cloud_report "datadog" do
 message "DataDog::Install End"
end
