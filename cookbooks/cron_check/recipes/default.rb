# Recipe for testing cron is working properly.
#
cron "timestamp_check" do
  user node[:owner_name]
  minute "*"
  hour "*"
  day "*"
  month "*"
  weekday "*"
  command "touch /home/#{node[:owner_name]}/cron.timestamp.check"
  action :create
end

template "/etc/monit.d/cron_timestamps.monitrc" do
  backup 0
  source "cron_check.monitrc.erb"
  owner "root"
  group "root"
  mode 0655
  variables({
  :owner => node[:owner_name]
  })
end

execute "reload monit" do
  command "monit reload"
end
