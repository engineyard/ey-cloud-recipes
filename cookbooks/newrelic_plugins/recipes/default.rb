#
# Cookbook Name:: newrelic_plugins
# Recipe:: default
#
# Copyright 2013, Engine Yard, Inc
#
# All rights reserved - Do Not Redistribute
#

easy_install_package 'pip' do
  action :install
end

bash 'install newrelic-plugin-agent' do
  user 'root'
  code 'pip install newrelic-plugin-agent'
end

template '/etc/newrelic_plugin_agent.yml' do
  source 'newrelic_plugin_agent.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :license_key => ''
  )
end

cookbook_file '/etc/monit.d/newrelic_plugin_agent.monitrc' do
  source 'newrelic_plugin_agent.monitrc'
  owner 'root'
  group 'root'
  mode 0644
end

cookbook_file '/etc/init.d/newrelic_plugin_agent' do
  source 'newrelic_plugin_agent.initd'
  owner 'root'
  group 'root'
  mode 0755
end

bash 'add to run level' do
  user 'root'
  code 'rc-update add newrelic_plugin_agent default'
end

execute 'monit reload' do
  action :run
end
