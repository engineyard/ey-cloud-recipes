cron_hour = if node[:backup_interval].to_s == '24'
              "1"    # 0100 Pacific, per support's request
              # NB: Instances run in the Pacific (Los Angeles) timezone
            elsif node[:backup_interval]
              "*/#{node[:backup_interval]}"
            else
              "1"
            end

template "/etc/.postgresql.backups.yml" do
  owner 'root'
  group 'root'
  mode 0600
  backup 0
  source "backups.yml.erb"
  variables({
    :dbuser => node[:users].first[:username],
    :dbpass => node[:users].first[:password],
    :keep   => node[:backup_window] || 14,
    :id     => node[:aws_secret_id],
    :key    => node[:aws_secret_key],
    :env    => node[:environment][:name],
    :region => node.engineyard.environment.region,
    :backup_bucket => node.engineyard.environment.backup_bucket,
    :databases => node.engineyard.apps.map {|app| app.database_name.downcase }
  })
end

# remove old MySQL backup... 
if ['solo', 'db_master'].include?(node[:instance_role])
  cron "mysql" do
    action :delete
  end
end

if ['solo', 'db_master'].include?(node[:instance_role])
  cron "postgresql" do
    minute    '10'
    hour      cron_hour
    day       '*'
    month     '*'
    weekday   '*'
    command   '/usr/local/ey_resin/bin/eybackup -e postgresql --quiet'
    not_if { node[:backup_window].to_s == '0' }
    action :create
  end
end
