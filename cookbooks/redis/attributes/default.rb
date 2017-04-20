default[:redis] = {
  :utility_name => "redis",
  :slave_name => "redis_slave",
  :version => "3.2.3",
  :bindport => "6379",
  :unixsocket => "/tmp/redis.sock",
  :basename => "dump.rdb",
  :basedir => "/data/redis",
  :pidfile => "/var/run/redis_util.pid",
  :loglevel => "notice",
  :logfile => "/data/redis/redis.log",
  :timeout => 300000,
  :saveperiod => ["900 1", "300 10", "60 10000"],
  :databases => 16,
  :rdbcompression => "yes",
  :hz => 10
}
default[:redis][:is_redis_instance] = (
  (node[:instance_role] == 'util') &&
  [default[:redis][:utility_name], default[:redis][:slave_name]].include?(node[:name])
)
