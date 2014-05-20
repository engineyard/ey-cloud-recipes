#
# Cookbook Name:: logrotate
# Recipe:: default
#

remote_file "/etc/logrotate.d/nginx" do
  source "nginx.logrotate"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

cron "logrotate -f /etc/logrotate.d/nginx" do
  minute  '0'
  command "logrotate -f /etc/logrotate.d/nginx"
  user "root"
end
