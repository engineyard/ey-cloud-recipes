#
# Cookbook Name:: datadog
# Recipe:: default
#

# Set your API key in the default attributes file or the Chef run will fail
# raise if node['datadog']['api_key'].nil? || node['datadog']['api_key'].empty?

# stop the agent before the install if it is already on there
execute "monit-stop-dd" do
 user "root"
 cwd "/"
 command "monit stop datadog_wrapper"
 only_if { File.exists?( '/var/run/datadog_wrapper.pid') }
end

# the dd setup script installs the agent
include_recipe "datadog::install"

# use monit and a wrapper script
include_recipe "datadog::daemonize"

# comment out if you want to use the standard config
include_recipe "datadog::config"

#uncomment this for the nginx integrations to work

# on app servers and staging install the nginx integrations
#if ['app_master','app','solo'].include? node[:instance_role]
#  include_recipe "datadog::nginx"
#end

# finish up
include_recipe "datadog::finish"
