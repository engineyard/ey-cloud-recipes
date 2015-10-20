#
# Cookbook Name:: fail2ban
# Recipe:: default
#
#
# install package

ey_cloud_report "Fail2Ban" do
  message "Installing Fail2Ban"
end

enable_package "net-analyzer/fail2ban" do
  version node['fail2ban']['version']
end

package 'net-analyzer/fail2ban' do
  version node['fail2ban']['version']
  action :install
end

# configuration of fail2ban.conf
fail2ban_replace_line "fail2ban conf loglevel" do
    replace  "loglevel="
    with     "loglevel=#{node['fail2ban']['loglevel']}"
    path     "/etc/fail2ban/fail2ban.conf"
end

fail2ban_replace_line "fail2ban conf logtarget" do
    replace  "logtarget="
    with     "logtarget=#{node['fail2ban']['logtarget']}"
    path     "/etc/fail2ban/fail2ban.conf"
end

fail2ban_replace_line "fail2ban conf socket" do
    replace  "socket="
    with     "socket=#{node['fail2ban']['socket']}"
    path     "/etc/fail2ban/fail2ban.conf"
end

file_replace_line "fail2ban conf pidfile" do
    replace  "pidfile="
    with     "pidfile=#{node['fail2ban']['pidfile']}"
    path     "/etc/fail2ban/fail2ban.conf"
end

include_recipe "fail2ban::service"

include_recipe "fail2ban::jails"
