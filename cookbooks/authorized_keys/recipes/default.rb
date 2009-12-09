require 'pp'
#
# Cookbook Name:: thinking_sphinx
# Recipe:: default
#

remote_file "/home/#{node[:owner_name]}/.ssh/authorized_keys" do
  owner "root"
  group "root"
  mode 0600
  source "user.authorized_keys"
  backup false
  action :create
end
    
remote_file "/root/.ssh/authorized_keys" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0600
  source "root.authorized_keys"
  backup false
  action :create
end

