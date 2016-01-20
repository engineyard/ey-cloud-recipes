default[:passenger_monitor4] = {
  # your EY Cloud application name
  :app_name => "myapp",

  # passenger worker memory limit, in MB
  :memory_limit => 300,

  # When a worker hits or exceeds the memory limit, we attempt to kill it with kill -USR1 <PID>
  # Due to this bug: https://github.com/phusion/passenger/wiki/Phusion-Passenger:-Node.js-tutorial#restarting_apps_that_serve_long_running_connections,
  # kill -USR1 does not always succeed. When that happens we send a kill -9 <PID> after waiting grace_time seconds
  :grace_time => 30
}
