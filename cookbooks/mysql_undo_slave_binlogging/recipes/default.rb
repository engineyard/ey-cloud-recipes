#
# Cookbook Name:: mysql_undo_slave_binlogging 
# Recipe:: default
#
template "/etc/mysql.d/ey_skip_slave_binlog.cnf" do
  source "ey_skip_slave_binlog.cnf.erb"
  owner 'root'
  group 'root'
  mode 0644
end
