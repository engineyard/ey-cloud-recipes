# Add your required timezone name here:
# If using JRuby with Trinidad, you must also modify the env.custom file with the desired timezone
# ex: add_java_option -Duser.timezone=UTC
timezone = "UTC"


service "vixie-cron"
service "sysklogd"
service "nginx"

link "/etc/localtime" do
  to "/usr/share/zoneinfo/#{timezone}"
  notifies :restart, resources(:service => ["vixie-cron", "sysklogd", "nginx"]), :delayed
  not_if "readlink /etc/localtime | grep -q '#{timezone}$'"
end
