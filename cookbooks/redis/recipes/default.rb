#
# Cookbook Name:: redis
# Recipe:: default
#

redis_version = node[:redis][:version]
redis_config_file_version = redis_version.split('.')[0..1].join('.')
redis_url = "http://download.redis.io/releases/redis-#{redis_version}.tar.gz"
redis_installer_directory = '/opt/redis-source'
bin_path = '/usr/local/bin'

if ['util'].include?(node[:instance_role])
  if node[:name] == node[:redis][:utility_name]

    sysctl "Enable Overcommit Memory" do
      variables 'vm.overcommit_memory' => 1
    end

    # Download Redis, if it hasn't been downloaded yet
    remote_file "/opt/redis-#{redis_version}.tar.gz" do
      source "#{redis_url}"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      not_if { FileTest.exists?(redis_installer_directory) }
    end

    execute "unarchive Redis installer" do
      cwd "/opt"
      command "tar zxf redis-#{redis_version}.tar.gz && sync"
      not_if { FileTest.directory?(redis_installer_directory) }
    end

    execute "rename /opt/redis-#{redis_version} to /opt/redis-source" do
      command "mv /opt/redis-#{redis_version} #{redis_installer_directory}"
      not_if { FileTest.directory?(redis_installer_directory) }
    end

    execute "run redis-source/make install" do
      cwd redis_installer_directory
      command "make install"
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
      source "redis-#{redis_config_file_version}.conf.erb"
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
        :hz => node[:redis][:hz]
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
        :bin_path => bin_path
      })
    end

    execute "monit reload" do
      action :run
    end
  end
end

if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])
  instances = node[:engineyard][:environment][:instances]
  redis_instance = (node[:instance_role][/solo/] && instances.length == 1) ? instances[0] : instances.find{|i| "redis" == i[:name]}

  if redis_instance
    ip_address = `ping -c 1 #{redis_instance[:private_hostname]} | awk 'NR==1{gsub(/\\(|\\)/,"",$3); print $3}'`.chomp
    host_mapping = "#{ip_address} redis-instance"

    execute "Remove existing redis-instance mapping from /etc/hosts" do
      command "sudo sed -i '/redis-instance/d' /etc/hosts"
      action :run
    end

    execute "Add redis-instance mapping to /etc/hosts" do
      command "sudo echo #{host_mapping} >> /etc/hosts"
      action :run
    end
  end
end
