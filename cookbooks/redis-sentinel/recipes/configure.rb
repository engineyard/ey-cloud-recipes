#
# Cookbook Name:: redis-sentinel
# Recipe:: configure
#

redis_master = node['utility_instances'].select{ |i| i[:name] == 'redis'}.first

# Skip everything if there is no redis instance
if redis_master
  redis_master_hostname = redis_master[:hostname]

  sentinel_instances = node['utility_instances'].map { |i| i['hostname'] if i['name'] == node['redis-sentinel']['utility_name'] }.compact
  sentinels_for_redis_yml = sentinel_instances.map do |i|
    { 'host' => i, 'port' => node['redis-sentinel']['port'] }
  end

  # Generate a redis-sentinel.yml in /data/appname/shared/config
  # so that the application can know which redis-sentinel instances to talk to
  if %w(solo app app_master util).include?(node['instance_role'])
    node['applications'].each do |app, _data|
      template "/data/#{app}/shared/config/redis-sentinel.yml" do
        source 'redis-sentinel.yml.erb'
        owner node['owner_name']
        group node['owner_name']
        mode 0655
        backup 0
        variables('sentinel_instances' => sentinel_instances,
                  'port' => node['redis-sentinel']['port'])
      end
    end
  end

  # Override the redis.yml in /data/appname/shared/config
  # Redis clients should connect to the sentinels, not directly to redis master
  if %w(solo app app_master util).include?(node['instance_role'])
    node['applications'].each do |app, _data|
      template "/data/#{app}/shared/config/redis.yml" do
        source 'redis.yml.erb'
        owner node['owner_name']
        group node['owner_name']
        mode 0655
        backup 0
        variables({
          'environment' => node['environment']['framework_env'],
          'sentinels' => sentinels_for_redis_yml,
          'redis_url' => "redis://#{redis_master_hostname}"
        })
      end
    end
  end

end
