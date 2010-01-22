require 'pp'
#
# Cookbook Name:: ssmtp
# Recipe:: default
#

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

  directory "/etc/ssmtp" do
    recursive true
    action :delete
  end

  link "/etc/ssmtp" do
    to '/data/ssmtp'
  end

end
