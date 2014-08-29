#
# Cookbook Name:: varnish
# Recipe:: default
#

require 'etc'

if ['solo','app_master', 'app'].include?(node[:instance_role])

  # This needs to be in keywords: www-servers/varnish ~x86
  # This makes sure that it is.

  enable_package "www-servers/varnish" do
    version '3.0.5-r1'
  end

  package "www-servers/varnish" do
    version '3.0.5-r1'
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

  # Here we find out how many cores the VM has on it. The basic formula here is:
  # thread pools = num cores
  # thread pool max = num cores * 1000
  # overflow max = thread pool max * 2
  # cache is always malloc,1GB.
  num_cores = File.read("/proc/cpuinfo").scan(/processor\s+:\s+\d\s/).size

  # safety check - return num_cores or 1 if count == zero for whatever reason
  # since we know we'll always have at least one CPU core (how could we not?)
  num_cores = (num_cores > 0 ? num_cores : 1)

  # Get info about the VM's memory. The kernel seems to always return total memory
  # on the first line and always measured in kilobytes, so we need multiply by
  # 1024 to get the actual amount of memory in bytes on the machine.
  mem_bytes = File.read("/proc/meminfo").scan(/\d+/).first.to_f * 1024

  # Figure out how much memory to use for varnish. Either 1GB or 25% of total memory
  # on the box, whichever is greater. Note that Varnish always assumes that memory
  # max storage is in BYTES, not gigs, megs, kb, etc. unless otherwise specified
  # (reference: https://www.varnish-cache.org/docs/3.0/reference/varnishd.html#storage-types)
  if (mem_bytes * 0.25) < (1024 * 1024 * 1024) # 1GB
    malloc_mem = "1GB"
  else
    malloc_mem = mem_bytes * 0.25
  end

  # Set the variables for tuning Varnish now that we have sufficient information.
  thread_pools = num_cores
  thread_pool_max = num_cores * 1000
  overflow_max = thread_pool_max * 2
  cache = "malloc,#{malloc_mem}"

  # Install the varnish monit file.
  template '/usr/local/bin/varnishd_wrapper' do
    mode 755
    source 'varnishd_wrapper.erb'
    variables({
      :thread_pools => thread_pools,
      :thread_pool_max => thread_pool_max,
      :overflow_max => overflow_max,
      :cache => cache,
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
