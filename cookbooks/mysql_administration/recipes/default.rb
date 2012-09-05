#
# Cookbook Name:: mysql_administration 
# Recipe:: default
#
if ['db_slave'].include?(node[:instance_role])
  if skip_slave_binlog
    require_recipe "mysql_administration::skip_slave_binlog"
  end
end