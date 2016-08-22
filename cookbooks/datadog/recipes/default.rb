#
# Cookbook Name:: datadog
# Recipe:: default
#

# Set your API key in the default attributes file or the Chef run will fail
# raise if node['datadog']['api_key'].nil? || node['datadog']['api_key'].empty?

# stop the agent before the install if it is already on there


execute "monit-stop-dd" do
 user "deploy"
 cwd "/"
 command "monit stop datadog_wrapper; sleep 30"
 only_if " pgrep 'datadog_wrapper' > /dev/null"
end

# the dd setup script installs the agent
include_recipe "datadog::install"

# use monit and a wrapper script
include_recipe "datadog::daemonize"

# comment out if you want to use the standard config
include_recipe "datadog::config"

# uncomment for the postgres extension
# include_recipe "datadog::postgres"

# finish up
include_recipe "datadog::finish"
