#
# Cookbook Name:: fail2ban
# Recipe:: services
#
#

ey_cloud_report "Fail2Ban-service" do
	message "Fail2Ban service & monitoring"
end

# enabling the service
service 'fail2ban' do
	supports [:status => true, :restart => true]
	action [:enable, :start]
	status_command "/etc/init.d/fail2ban status | grep -q 'status: started'"
end

# adding monitrc rules to let the service up
execute "restart-monit" do
  command "monit reload && sleep 2s && monit quit"
  action :nothing
end

cookbook_file "/etc/monit.d/fail2ban.monitrc" do
	source "fail2ban.monitrc"
	owner node[:owner_name]
	group node[:owner_name]
	mode 0644
	backup false
	action :create
	notifies :run, resources(:execute => "restart-monit")
end
