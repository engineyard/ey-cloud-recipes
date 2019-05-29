#
# Cookbook Name:: collectd-custom
# Recipe:: recompile
#
# Deletes collectd-custom and recompiles it. Useful if you added a package that's a plugin dependency.
#

service node['collectd-custom']['service_name'] do
  action [ :disable, :stop ]
end

execute "remove_collectd_custom" do
  command "rm -rf #{node['collectd-custom']['dir']}"
  action :run
end

include_recipe "collectd-custom"

ruby_block "remove_recipe_collectd_recompile" do
  block { node.run_list.remove("recipe[collectd-custom::recompile]") }
end
