if ['app_master', 'app'].include?(node[:instance_role])
  # WHEN GIVING INSTRUCTIONS IN DOC
  # AND IN README, LET THE CUSTOMER KNOW TO MODIFY THIS LINE
  # SO THAT IT FINDS THEIR REDIS INSTANCE
  redis_instance = node['utility_instances'].first #find { |instance| instance['name'] == 'redis' }
  
  if redis_instance
    node[:applications].each do |app, data|
      template "/data/#{app}/shared/config/redis.yml"do
        source 'redis.yml.erb'
        owner node[:owner_name]
        group node[:owner_name]
        mode 0655
        backup 0
        variables({
          :environment => node[:environment][:framework_env],
          :hostname => redis_instance[:hostname]
        })
      end
    end
  end
end