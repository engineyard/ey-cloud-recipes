default[:redis] = {
  :utility_name => "redis",
  :version => "2.8.13-r1",
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
