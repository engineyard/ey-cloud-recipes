# backups disabled?
if node[:backup_window].to_s == "0"
  Chef::Log.info "Backups are disabled for this environment; skipping flexibackup recipe."
  return
end

env = node[:engineyard][:environment]
stack = env[:db_stack_name][/mysql|postgresql/]





# ****** Configuration options ******

bucket = 'flexibackup-stage-samanage-com'
database = 'frontend'                     # blank backs up all non-system databases
aws_key = node[:aws_secret_id]
aws_secret_key = node[:aws_secret_key]
source = node[:environment][:name]
retention = 10                            # 0 disables file cleanup
remove_eybackup = false                   # removes the standard eybackup from the host the backup is scheduled on


#--- Use only one of these conditions or define your own
  # install on db master only
if node[:instance_role][/db_master/]
  # install on db replica named 'backup'
# if node[:name] == 'backup'

#---

# ****** End Configuration options ******

  
  
  
  
  ey_cloud_report "Installing flexibackup" do
    message "Starting flexibackup install..."
  end
  
  interval = node[:backup_interval]
  hour = interval.to_i == 24 ? "1" : (interval ? "*/#{interval}" : "1")

  fbpath='/db/flexibackup'
  
  directory "#{fbpath}/lib" do
    recursive true
    owner 'root'
    group 'root'
    mode 0755
  end
  
  directory "#{fbpath}/config" do
    recursive true
    owner 'root'
    group 'root'
    mode 0755
  end
  
  cookbook_file "#{fbpath}/flexibackup.rb" do
    source 'flexibackup.rb'
    owner 'root'
    group 'root'
    mode '744'
  end
  
  cookbook_file "#{fbpath}/lib/backup.rb" do
    source 'backup.rb'
    owner 'root'
    group 'root'
    mode '644'
  end
  
  cookbook_file "#{fbpath}/lib/flexparse.rb" do
    source 'flexparse.rb'
    owner 'root'
    group 'root'
    mode '644'
  end
  
  # check for encryption
  gpgkey = ''
  if node[:encrypted_backups]
    package "app-crypt/gnupg" do
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
    gpgkey = `gpg --list-keys --with-colon | awk -F: '$1=="pub"{print $5}'`.chomp
  end
  
  template "#{fbpath}/config/flexibackup_config.yml" do
    source 'flexibackup_config.yml.erb'
    owner 'root'
    group 'root'
    mode '644'
    variables({
      :retention => retention,
      :aws_key => aws_key,
      :aws_secret_key => aws_secret_key,
      :gpgkey => gpgkey,
      :source => source,
      :bucket => bucket
    })
  end
  
  # Uncomment this to remove eybackup schedule from this host
  if remove_eybackup
    cron stack do
      action :delete
    end
  end
  
  database_option = (database.nil? or database == '') ? "" : "-d #{database}"
  
  cron "flexibackup custom backups" do
    minute '15'
    hour hour
    user "root"
    command "#{fbpath}/flexibackup.rb -a create #{database_option} --tab >> /var/log/flexibackup.log 2>&1"
    action :create
  end
  
  ey_cloud_report "Installation of flexibackup" do
    message "complete!"
  end

else
  # cleanup this from other hosts in case a replica is promoted
  cron "flexibackup custom backups" do
    action :delete
  end
end

