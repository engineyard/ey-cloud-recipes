#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2011, Treasure Data, Inc.
#

td_api_key = node[:td_agent_api_key]

ey_cloud_report "Installing Treasure Data Agent" do
  message "installing Treasure Data Agent"
end

#group 'td-agent' do
  #group_name 'td-agent'
  #gid        403
  #action     :create
#end

#user 'td-agent' do
  #comment  'td-agent'
  #uid      403
  #group    'td-agent'
  #home     '/var/run/td-agent'
  #shell    '/bin/false'
  #password nil
  #supports :manage_home => true
  #action   :create, :manage
#end

directory "/etc/td-agent/" do
  owner  node[:owner_name]
  group  node[:owner_name]
  mode   0755
  action :create
end

#case node['platform']
#when "ubuntu"
  #dist = node['lsb']['codename']
  #source = (dist == 'precise') ? "http://packages.treasure-data.com/precise/" : "http://packages.treasure-data.com/debian/"
  #apt_repository "treasure-data" do
    #uri source
    #distribution dist
    #components ["contrib"]
    #action :add
  #end
#when "centos", "redhat"
  #yum_repository "treasure-data" do
    #url "http://packages.treasure-data.com/redhat/$basearch"
    #action :add
  #end
#end

template "/etc/td-agent/td-agent.conf" do
  mode "0644"
  source "td-agent.conf.erb"
end

#package "td-agent" do
  #options "-f --force-yes"
  #action :upgrade
#end

#service "td-agent" do
  #action [ :enable, :start ]
  #subscribes :restart, resources(:template => "/etc/td-agent/td-agent.conf")
#end
