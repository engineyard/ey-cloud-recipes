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

# clean default unused filters and actions
execute "clear-unused-fail2ban-actions" do
  command "find /etc/fail2ban/action.d -mindepth 1 -maxdepth 1 -type f ! -name iptables.conf ! -name hostsdeny.conf -delete"
  action :run
end

execute "clear-unused-fail2ban-filters" do
  command "find /etc/fail2ban/filter.d -mindepth 1 -maxdepth 1 -type f ! -name common.conf ! -name sshd.conf -delete"
  action :run
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

template "/etc/monit.d/fail2ban.monitrc" do
  source "fail2ban.monitrc.erb"
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  backup false
  variables({
    :user => node[:owner_name],
    :group => node[:owner_name]
  })
  notifies :run, resources(:execute => "restart-monit")
end