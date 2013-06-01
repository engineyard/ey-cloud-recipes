#
# Cookbook Name:: eybackup_slave
# Recipe:: default
#

# backups disabled?
if node[:backup_window].to_s == "0"
  raise "Backups are disabled for this environment"
end

# database is mysql? (EY Cloud already sets up eybackup on the slave for postgres)
env = node[:engineyard][:environment]
stack = env[:db_stack_name][/mysql|postgresql/]

# find database slave node
db_slave = env[:instances].find{|i| i[:role][/db_slave/]}

if db_slave
  # calculate hour
  interval = node[:backup_interval]
  hour = interval.to_i == 24 ? "1" : (interval ? "*/#{interval}" : "1")

  # backup command
  backup_command = "/usr/local/ey_resin/bin/eybackup -e #{stack}"

  # check for encryption
  if node[:encrypted_backups]
    # require encrypted recipe
    include_recipe 'eybackup_slave::encrypted'
    
    # add the -k flag to the command
    key = `gpg --list-keys --with-colon | awk -F: '$1=="pub"{print $5}'`
    backup_command << " -k #{key}" unless key.empty?
  end

  backup_command << " /var/log/eybackup.log"
  
  # remove db master cronjob
  if node[:instance_role][/db_master/]
    cron stack do
      action :delete
    end
  end

  # setup cronjob on db slave
  if node[:engineyard][:this] == db_slave[:id]
    cron stack do
      minute "10"
      hour hour
      day "*"
      month "*"
      weekday "*"
      command >> backup_command
    end  
  end
else
  Chef::Log.info "There is no database slave available, leaving eybackup cronjob on the database master"
end
