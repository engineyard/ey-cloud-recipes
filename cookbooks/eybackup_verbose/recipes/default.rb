# Copyright Engine Yard - 2010

#set backup interval
cron_hour = if node[:backup_interval].to_s == '24'
              "1"    # 0100 Pacific, per support's request
              # NB: Instances run in the Pacific (Los Angeles) timezone
            elsif node[:backup_interval]
              "*/#{node[:backup_interval]}"
            else
              "1"
            end


if ['solo', 'db_master'].include?(node[:instance_role])
  cron "eybackup" do
    action :delete
  end

  cron "eybackup" do
    minute   '10'
    hour     cron_hour
    day      '*'
    month    '*'
    weekday  '*'
    command  "/usr/local/ey_resin/bin/eybackup >> /db/eybackup.log"
    not_if { node[:backup_window].to_s == '0' }
  end  

  cron "ey-snapshots" do
    action :delete
  end
  

  cron "ey-snapshots" do
    minute   '0'
    hour     cron_hour
    day      '*'
    month    '*'
    weekday  '*'
    command  "ey-snapshots --snapshot >> /db/ey-snapshots.log"
    not_if { node[:backup_window].to_s == '0' }
  end
end
