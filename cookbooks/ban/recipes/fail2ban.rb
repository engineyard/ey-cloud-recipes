# install fail2ban
enable_package "net-analyzer/fail2ban" do
  version "0.8.3"
end

package "net-analyzer/fail2ban" do
  version "0.8.3"
  action :install
end

# fail2ban service
service "fail2ban" do
  supports :reload => true
end

# clean default filters and actions
execute "clear-fail2ban-actions-and-filters" do
  command "find /etc/fail2ban/{action.d,filter.d} -mindepth 1 -type f -delete"
  action :run
end

# copy filters and actions
remote_directory "/etc/fail2ban/action.d" do
  source "action.d"
end

remote_directory "/etc/fail2ban/filter.d" do
  source "filter.d"
end

# jail.conf
template "/etc/fail2ban/jail.conf" do
  source "jail.conf.erb"
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  backup false
  notifies :reload, resources(:service => 'fail2ban')
end

# setup monitoring with monit
execute "restart-monit" do
  command "monit reload && wait 2s && monit quit"
  action :nothing
end

remote_file "/etc/monit.d/fail2ban.monitrc" do
  source "fail2ban.monitrc"
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  backup false
  notifies :run, resources(:execute => "restart-monit")
end