#
# Cookbook Name:: xorg-server
# Recipe:: default
#
require_recipe 'xorg-server::install'

template "/engineyard/bin/xvfb-run" do
  owner 'root'
  group 'root'
  mode '0755'
  source "xvfb-run.erb"
end
