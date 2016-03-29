app_name = node[:passenger_monitor4][:app_name]
memory_limit = node[:passenger_monitor4][:memory_limit]
grace_time = node[:passenger_monitor4][:grace_time]

# Installs the updated passenger_monitor4 script
cookbook_file "/engineyard/bin/passenger_monitor4" do
  owner "root"
  group "root"
  mode 0755
  source "passenger_monitor4"
  backup false
  action :create
end

# Updates the passenger_monitor_appname cron job
cron "passenger_monitor_#{app_name}" do
  minute '*'
  hour '*'
  day '*'
  weekday '*'
  month '*'
  command "/usr/bin/lockrun --lockfile=/var/run/passenger_monitor4_#{app_name}.lockrun -- /bin/bash -c '/engineyard/bin/passenger_monitor4 #{app_name} -l #{memory_limit} -w #{grace_time} >/dev/null 2>&1'"
end
