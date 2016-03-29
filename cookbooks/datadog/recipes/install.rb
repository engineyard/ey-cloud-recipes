#
#oh you thought you could emerge this on gentoo....nope welcome
#

ey_cloud_report "datadog" do
 message "DataDog::Install Start"
end

cookbook_file 'copy in setup script' do
	path '/root/setup_agent.sh'
  source 'setup_agent.sh'
  owner 'root'
  group 'root'
  mode '744'
	not_if { File.exists?( '/root/setup_agent.sh')  }
end

bash 'run the setup script' do
 user 'root'
 cwd '/root'
 code <<-EOH
  DD_API_KEY=#{node['datadog']['api_key']} sh ./setup_agent.sh
	EOH
 notifies :run, 'execute[rm-setup-tools]', :immediately
 not_if "test -f /root/.datadog-agent/bin/agent"
end

execute 'rm-setup-tools' do
 command "find /root -name 'setuptools-*.zip' | xargs rm"
 action :nothing
 only_if { !Dir.glob('/root/setuptools*.zip').empty? }
end

ey_cloud_report "datadog" do
 message "DataDog::Install End"
end
