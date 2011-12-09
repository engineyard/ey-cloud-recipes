#
# Cookbook Name:: jruby
# Recipe:: default
#

package "dev-java/sun-jdk" do
  action :install
end

package "dev-java/jruby-bin" do
  action :install
end

execute "install-glassfish" do
  command "/usr/bin/jruby -S gem install glassfish"
end

#####
#
# Edit this to point to YOUR app's directory
#
#####

APP_DIRECTORY = '/data/hello_world/current'

#####
#
# These are generic tuning parameters for each instance size; you may want to further tune them for
# your application's specific needs if they prove inadequate.
# In particular, if you have a thread-safe application, you will _definitely_ only want a single
# runtime.
#
#####

size = `curl -s http://instance-data.ec2.internal/latest/meta-data/instance-type`
case size
when /t1.micro/ # 0.6G RAM, 1 ECU, 32- or 64-bit  ## should never use micros but set defaults just in case 
  JVM_CONFIG = '-server -Xmx512m -Xms512m -XX:MaxPermSize=128m -XX:PermSize=128m -XX:NewRatio=2 -XX:+DisableExplicitGC'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 1
when /m1.small/ # 1.7G RAM, 1 ECU, 32-bit
  JVM_CONFIG = '-server -Xmx1g -Xms512m -XX:MaxPermSize=256m -XX:PermSize=256m -XX:NewRatio=2 -XX:+DisableExplicitGC'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 1
when /m1.large/ # 7.5G RAM, 4 ECU, 64-bit
  JVM_CONFIG = '-server -Xmx2g -Xms512m -XX:MaxPermSize=256m -XX:PermSize=256m -XX:NewRatio=2 -XX:+DisableExplicitGC'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 4
when /m1.xlarge/ # 15G RAM, 8 ECU, 64-bit
  JVM_CONFIG = '-server -Xmx2.5g -Xms512m -XX:MaxPermSize=378m -XX:PermSize=378m =XX:NewRatio=2'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 8
when /c1.medium/ # 1.7G RAM, 5 ECU, 32-bit
  JVM_CONFIG = '-server -Xmx1g -Xms512m -XX:MaxPermSize=256m -XX:PermSize=256m =XX:NewRatio=2'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 5
when /c1.xlarge/ # 7.0G RAM, 20 ECU, 64-bit
  JVM_CONFIG = '-server -Xmx4g -Xms512m -XX:MaxPermSize=1024m -XX:PermSize=512m =XX:NewRatio=2'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 20
when /m2.xlarge/ # 17.1G RAM, 6.5 ECU, 64-bit
  JVM_CONFIG = '-server -Xmx4g -Xms512m -XX:MaxPermSize=1024m -XX:PermSize=512m =XX:NewRatio=2'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 8
when /m2.2xlarge/ # 34.2G RAM, 13 ECU, 64-bit
  JVM_CONFIG = '-server -Xmx4g -Xms512m -XX:MaxPermSize=1024m -XX:PermSize=512m =XX:NewRatio=2'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 8
when /m2.4xlarge/ # 68G RAM, 26 ECU, 64-bit
  JVM_CONFIG = '-server -Xmx4g -Xms512m -XX:MaxPermSize=1024m -XX:PermSize=512m =XX:NewRatio=2'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 8
else # This shouldn't happen, but do something rational if it does.
  JVM_CONFIG = '-server -Xmx1g -Xms1g -XX:MaxPermSize=256m -XX:PermSize=256m -XX:NewRatio=2 -XX:+DisableExplicitGC'
  JRUBY_RUNTIME_POOL_INITIAL = 1
  JRUBY_RUNTIME_POOL_MIN = 1
  JRUBY_RUNTIME_POOL_MAX = 1
end

  require 'yaml'
  File.open('/tmp/node.out','w+') {|fh| fh.puts node.to_yaml }

# Install the glassfish configuration file.
template File.join([APP_DIRECTORY],'config','glassfish.yml') do
  owner node[:owner_name]
  group node[:owner_name]
  source 'glassfish.yml.erb'
  variables({
    :environment => 'development',
    :port => 3000,
    :contextroot => '/',
    :log_level => 3,
    :jruby_runtime_pool_initial => JRUBY_RUNTIME_POOL_INITIAL,
    :jruby_runtime_pool_min => JRUBY_RUNTIME_POOL_MIN,
    :jruby_runtime_pool_max => JRUBY_RUNTIME_POOL_MAX,
    :daemon_enable => 'false', # It will be daemonized, but leave this as false for now.
    :jvm_options => JVM_CONFIG
  })
end

# Install the glassfish start/stop script.
template '/etc/init.d/glassfish' do
  owner 'root'
  group 'root'
  mode 0755
  source 'init.d-glassfish.erb'
end

execute "ensure-glassfish-is-running" do
    command %Q{
      /etc/init.d/glassfish start --config /data/hello_world/current/config/glassfish.yml  /data/hello_world/current
    }
end
