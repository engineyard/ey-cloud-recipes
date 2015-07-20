#
# Cookbook Name:: eybackup_slave
# Recipe:: default
#

# backups disabled?
if node[:backup_window].to_s == "0"
  Chef::Log.info "Backups are disabled for this environment; skipping eybackup_slave recipe."
  return
end

# database is mysql? (EY Cloud already sets up eybackup on the slave for postgres)
env = node[:engineyard][:environment]
stack = env[:db_stack_name][/mysql|postgresql/]

# find database slave node
db_slave = env[:instances].find{|i| i[:role][/db_slave/]}

if db_slave
  if node[:engineyard][:this] == db_slave[:id]
    # calculate hour
    interval = node[:backup_interval]
    hour = interval.to_i == 24 ? "1" : (interval ? "*/#{interval}" : "1")

    # backup command
    backup_command = "/usr/local/ey_resin/bin/eybackup -e #{stack}"

    # check for encryption
    if node[:encrypted_backups]
      # gnupg package
      package "app-crypt/gnupg" do
        version '2.0.9'
        action :install
      end

      # public key
      template "/root/backup_pgp_key" do
        source "key.erb"
        owner 'root'
        group 'root'
        mode 0644
        backup 0
        variables({
          :key => node[:public_key]
        })
      end
    
      # import key
      execute "gpg --import /root/backup_pgp_key" if node[:public_key]
    
      # add the -k flag to the command
      key = `gpg --list-keys --with-colon | awk -F: '$1=="pub"{print $5}'`
      backup_command << " -k #{key}".rstrip unless key.empty?
    end

    backup_command << " >> /var/log/eybackup.log"

    # setup cronjob on db slave
    cron stack do
      minute "10"
      hour hour
      user "root"
      command backup_command
      action :create
    end  
  end
  
  # remove db master cronjob
  if node[:instance_role][/db_master/]
    cron stack do
      action :delete
    end
  end
else
  Chef::Log.info "There is no database slave available, leaving eybackup cronjob on the database master"
end
