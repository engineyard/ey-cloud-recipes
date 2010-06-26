#
# Cookbook Name:: redis
# Recipe:: default
#

if ['util'].include?(node[:instance_role])

execute "install_redis_1.3.7_pre1" do
  command "ACCEPT_KEYWORDS=\"~amd64 ~x86\" emerge -v dev-db/redis"
  not_if { FileTest.exists?("/usr/bin/redis-server") }
end

directory "/data/redis" do
  owner 'redis'
  group 'redis'
  mode 0755
  recursive true
end

template "/etc/redis_util.conf" do
  owner 'root'
  group 'root'
  mode 0644
  source "redis.conf.erb"
  variables({
    :pidfile => '/var/run/redis_util.pid',
    :basedir => '/data/redis',
    :logfile => '/data/redis/redis.log',
    :port  => '6379',
    :loglevel => 'notice',
    :timeout => 3000,
  })
end

template "/data/monit.d/redis_util.monitrc" do
  owner 'root'
  group 'root'
  mode 0644
  source "redis.monitrc.erb"
  variables({
    :profile => '1',
    :configfile => '/etc/redis_util.conf',
    :pidfile => '/var/run/redis_util.pid',
    :logfile => '/data/redis',
    :port => '6379',
  })
end

execute "monit reload" do
  action :run
end
end
