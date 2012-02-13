#
# Cookbook Name:: varnish
# Recipe:: default
#

require 'etc'

if ['solo','app_master', 'app'].include?(node[:instance_role])

  # This needs to be in keywords: www-servers/varnish ~x86
  # This makes sure that it is.

  enable_package "www-servers/varnish" do
    version '2.0.6'
  end

  package "www-servers/varnish" do
    version '2.0.6'
    action :install
  end

  ## Edit interface if needed
  INTERFACE="eth0"

  #####
  #
  # These are generic tuning parameters for each instance size. You may want to
  # tune them if they prove inadequate.
  #
  #####

  CACHE_DIR = '/var/lib/varnish'
  size = `curl -s http://instance-data.ec2.internal/latest/meta-data/instance-type`
  case size
  when /m1.small/ # 1.7G RAM, 1 ECU, 32-bit, 1 core
    THREAD_POOLS=1
    THREAD_POOL_MAX=1000
    OVERFLOW_MAX=2000
    CACHE="malloc,1GB"
  when /m1.large/ # 7.5G RAM, 4 ECU, 64-bit, 2 cores
    THREAD_POOLS=2
    THREAD_POOL_MAX=2000
    OVERFLOW_MAX=4000
    CACHE="malloc,1GB"
  when /m1.xlarge/ # 15G RAM, 8 ECU, 64-bit, 4 cores
    THREAD_POOLS=4
    THREAD_POOL_MAX=4000
    OVERFLOW_MAX=8000
    CACHE="malloc,1GB"
  when /c1.medium/ # 1.7G RAM, 5 ECU, 32-bit, 2 cores
    THREAD_POOLS=2
    THREAD_POOL_MAX=2000
    OVERFLOW_MAX=4000
    CACHE="malloc,1GB"
  when /c1.xlarge/ # 7G RAM, 20 ECU, 64-bit, 8 cores
    THREAD_POOLS=8
    THREAD_POOL_MAX=8000 # This might be too much.
    OVERFLOW_MAX=16000
    CACHE="malloc,1GB"
  when /m2.xlarge/ # 17.1G RAM, 6.5 ECU, 64-bit, 2 cores
    THREAD_POOLS=2
    THREAD_POOL_MAX=2000
    OVERFLOW_MAX=4000
    CACHE="malloc,1GB"
  when /m2.2xlarge/ # 34.2G RAM, 13 ECU, 64-bit, 4 cores
    THREAD_POOLS=4
    THREAD_POOL_MAX=4000
    OVERFLOW_MAX=8000
    CACHE="malloc,1GB"
  when /m2.4xlarge/ # 68.4G RAM, 26 ECU, 64-bit, 8 cores
    THREAD_POOLS=8
    THREAD_POOL_MAX=8000 # This might be too much.
    OVERFLOW_MAX=16000
    CACHE="malloc,1GB"
  else # This shouldn't happen, but do something rational if it does.
    THREAD_POOLS=1
    THREAD_POOL_MAX=2000
    OVERFLOW_MAX=2000
    CACHE="malloc,1GB"
  end

  # Install the varnish monit file.
  template '/usr/local/bin/varnishd_wrapper' do
    mode 755
    source 'varnishd_wrapper.erb'
    variables({
      :thread_pools => THREAD_POOLS,
      :thread_pool_max => THREAD_POOL_MAX,
      :overflow_max => OVERFLOW_MAX,
      :cache => CACHE,
      :varnish_port => 882
    })
  end

  # Install MOTD to ensure support is aware of iptables hackery.
  template '/etc/motd' do
    mode 655
    source 'motd.erb'
    variables({ :interface => INTERFACE })
  end

  template '/etc/monit.d/varnishd.monitrc' do
    owner node[:owner_name]
    group node[:owner_name]
    source 'varnishd.monitrc.erb'
  end

  # Install the app VCL file.
  template '/etc/varnish/app.vcl' do
    owner node[:owner_name]
    group node[:owner_name]
    source 'app.vcl.erb'
  end

  # Make sure the cache directory exists.
  unless FileTest.exist? CACHE_DIR
    user = Etc::getpwnam(node[:owner_name])
    Dir.mkdir(CACHE_DIR)
    File.chown(user.uid,user.gid,CACHE_DIR)
  end

  # Configure IPTables to redirect incomming traffic 
  # Start/restart varnish

  execute "Configure iptables" do
   command %Q{
     iptables -t nat -F && iptables -t nat -A PREROUTING -p tcp --dport 80 -i #{INTERFACE} -j REDIRECT --to-ports 882 && /etc/init.d/iptables save
   }
  end

  execute "Stop Varnish and bounce monit" do
    command %Q{
      sleep 20 ; pkill -9 monit && telinit q ; sleep 10 && monit
    }
  end

end
