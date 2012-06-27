#
# Cookbook Name:: redis
# Recipe:: default
#

if ['util'].include?(node[:instance_role])
  if node[:name] == 'redis'

    sysctl "Enable Overcommit Memory" do
      variables 'vm.overcommit_memory' => 1
    end

    enable_package "dev-db/redis" do
      version "2.4.6"
    end

    package "dev-db/redis" do
      version "2.4.6"
      action :upgrade
    end

    directory "#{node[:redis][:basedir]}" do
      owner 'redis'
      group 'redis'
      mode 0755
      recursive true
      action :create
    end

    template "/etc/redis_util.conf" do
      owner 'root'
      group 'root'
      mode 0644
      source "redis.conf.erb"
      variables({
                  :pidfile => node[:redis][:pidfile],
                  :basedir => node[:redis][:basedir],
                  :basename => node[:redis][:basename],
                  :logfile => node[:redis][:logfile],
                  :loglevel => node[:redis][:loglevel],
                  :port  => node[:redis][:bindport],
                  :unixsocket => node[:redis][:unixsocket],
                  :saveperiod => node[:redis][:saveperiod],
                  :timeout => node[:redis][:timeout],
                  :databases => node[:redis][:databases],
                  :rdbcompression => node[:redis][:rdbcompression],
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
                  :pidfile => node[:redis][:pidfile],
                  :logfile => node[:redis][:basename],
                  :port => node[:redis][:bindport],
                })
    end

    execute "monit reload" do
      action :run
    end
  end
end
