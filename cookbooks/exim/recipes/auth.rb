#
# Cookbook Name:: exim
# Recipe:: default
#
# Configuration settings

if ['solo', 'util'].include?(node[:instance_role])

  # CONFIGURATING SETTINGS HERE! DO NOT PUSH THESE VARIABLES UP TO GITHUB.
  # alternative to using this cookbook, use the default cookbook and setup 
  # exim.conf on your EBS and then be happy.

  smtp_host = "my.external.mailserver"
  my_hostname = "my.domain.com"
  smtp_username = "username"
  smtp_password "password"

package "mail-mta/ssmtp" do
  action :remove
  ignore_failure true
end

package "mail-mta/exim" do
  action :install
end

template "/etc/exim/exim.conf" do
  source "exim.conf.erb"
  mode 0644
  owner "root"
  group "root"
  backup 0
  variables(
    :smtp_host => smtp_host,
    :smtp_username => smtp_username,
    :smtp_password => smtp_password,
    :my_hostname => my_hostname
  )
end

directory "/data/exim" do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

execute "touch_passwd" do
  command "touch /data/exim/passwd"
  not_if { FileTest.exists?("/data/exim/passwd") }
end

link "/data/exim/passwd" do
  to "/etc/exim/passwd"
end

package "mail-client/mailx" do
  action :install
end

execute "ensure-exim-is-running" do
  command %Q{
    /etc/init.d/exim start
  }
  not_if "pgrep exim"
end
end
