#
# Cookbook Name:: redis-sentinel
# Recipe:: install
#
# This installs redis-sentinel on selected instances in the environment
#
# redis-sentinel is essentially redis-server running in sentinel mode
# so the code here looks very much like redis/recipes/install.rb
#

redis_version = node['redis-sentinel']['version']
redis_config_file_version = redis_version[0..2]
redis_download_url = node['redis-sentinel']['download_url']
redis_base_directory = node['redis-sentinel']['basedir']

run_installer = !FileTest.exists?(redis_base_directory) || node['redis-sentinel']['force_upgrade']

is_redis_sentinel_instance =  case node['redis-sentinel']['install_type']
                              when 'ALL_APP_INSTANCES'
                                %w(solo app_master app).include?(node['instance_role'])
                              else
                                (node['instance_role'] == 'util') &&
                                  (node['name'] == node['redis-sentinel']['utility_name'])
                              end

if is_redis_sentinel_instance

  sysctl 'Enable Overcommit Memory' do
    variables 'vm.overcommit_memory' => 1
  end

  if run_installer
    if node['redis-sentinel']['install_from_source']
      include_recipe 'redis-sentinel::install_from_source'
    else
      include_recipe 'redis-sentinel::install_from_package'
    end

    directory redis_base_directory do
      owner 'redis'
      group 'redis'
      mode 0o755
      recursive true
      action :create
    end
  end

  # Determine the redis master instance private IP
  redis_master = node['utility_instances'].select{ |i| i[:name] == 'redis'}.first
  redis_master_hostname = redis_master[:hostname] if redis_master
  redis_sentinel_config_variables = {
    'port' => node['redis-sentinel']['port'],
    'redis_name' => 'redis',
    'redis_master_hostname' => redis_master_hostname
  }
  template '/etc/redis-sentinel.conf' do
    owner 'root'
    group 'root'
    mode 0o644
    source 'redis-sentinel.conf.erb'
    variables redis_sentinel_config_variables
  end

  bin_path = if node['redis-sentinel']['install_from_source']
               '/usr/local/bin'
             else
               '/usr/sbin'
             end
  template '/engineyard/bin/redis-sentinel' do
    owner 'root'
    group 'root'
    mode 0o755
    source 'redis-sentinel.erb'
    variables('configfile' => '/etc/redis-sentinel.conf',
              'bin_path' => bin_path)
  end

  template '/data/monit.d/redis-sentinel.monitrc' do
    owner 'root'
    group 'root'
    mode 0o644
    source 'redis-sentinel.monitrc.erb'
    variables('port' => node['redis-sentinel']['port'])
  end

  execute 'monit reload' do
    action :run
  end
end
