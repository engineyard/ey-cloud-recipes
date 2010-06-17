# set backup interval
cron_hour = if node[:backup_interval].to_s == '24'
              "1"    # 0100 Pacific, per support's request
              # NB: Instances run in the Pacific (Los Angeles) timezone
            elsif node[:backup_interval]
              "*/#{node[:backup_interval]}"
            else
              "1"
            end


if ['db_master'].include?(node[:instance_role])
  cron "mysql" do
    action :delete
  end
end

if ['db_slave'].include?(node[:instance_role])
  cron "mysql" do
    minute   '10'
    hour     cron_hour
    day      '*'
    month    '*'
    weekday  '*'
    command  "/usr/local/ey_resin/bin/eybackup"
    not_if { node[:backup_window].to_s == '0' }
  end  
end
