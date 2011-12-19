#
# Cookbook Name:: exim
# Recipe:: default
#
# Configuration settings

package "mail-mta/ssmtp" do
  action :remove
  ignore_failure true
end

directory "/etc/ssmtp" do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

execute "touch /etc/ssmtp/ssmtp.conf" do
  command "touch /etc/ssmtp/ssmtp.conf"
end

package "mail-mta/exim" do
  action :install
end

execute  "symlink ssmtp" do
  command "ln -sfv /usr/sbin/exim /usr/sbin/ssmtp"
  not_if { FileTest.exists?("/usr/sbin/ssmtp") }
end

remote_file "/etc/logrotate.d/exim" do
  source "exim.logrotate"
  backup 0
  owner "root"
  group "root"
  mode 0644
end

package "mail-client/mailx" do
  action :install
end
