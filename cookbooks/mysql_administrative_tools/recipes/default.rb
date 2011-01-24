#
# Cookbook Name:: mysql_administrative_tools
# Recipe:: default
#

# TOOL SELECTION
# enable individual tools by setting to true
automate_flush_hosts = false

# 



if automate_flush_hosts  
  if "'db_master','db_replica'".include?(node[:instance_role])
    cron "flush-hosts" do
      minute   '10'
      hour     '4'
      day      '1'
      month    '*'
      weekday  '*'
      command  "/usr/bin/mysqladmin -uroot -p$(cat /root/.mytop|grep pass|awk -F'=' '{print $2}') flush-hosts"
    end
  end
end