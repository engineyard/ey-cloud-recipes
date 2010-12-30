#
# Cookbook Name:: mysql_replication_check
# Recipe:: default
#
#
# Cookbook Name:: mysql_replication_check
# Recipe:: default
#

# installation path for monitoring tool
install_path = '/data/monitoring'

# configuration of replication check script
check_vars = {
  # the number of seconds delay at which a warning alert is issued; default 30 minutes (1800 seconds)
  :warn_level => 1800,
  # the number of seconds delay at which a critical alert is issued; default 2 hours (7200 seconds)
  :crit_level => 7200,
  # valid email address to receive alerts
  :mail_recipient => '',
  # valid email address for sending email alerts
  :mail_sender => ''
}

if node[:instance_role].include?('db_master')
  
  directory "#{install_path}" do
    owner 'root'
    group 'root'
    mode 0755
    action :create
    recursive true
  end
  
  template "#{install_path}/replication_check.rb" do
    source "replication_check.rb.erb"
    owner 'root'
    group 'root'
    mode 0755
    variables(check_vars)
  end
  
  cron "replica_check" do
    minute   '10'
    hour     '*'
    day      '*'
    month    '*'
    weekday  '*'
    command  "#{install_path}/replication_check.rb"
  end
  
  cron "allow_success_message" do
    minute  '30'
    hour    '8'
    day     '*'
    month   '*'
    weekday '*'
    command "rm #{install_path}/send_message.txt"
  end
  
end