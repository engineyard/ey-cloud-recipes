#
# Cookbook Name:: resque
# Recipe:: default
#
if ['util'].include?(node[:instance_role]) && node[:name] =~ /^Worker/
  
  execute "install resque gem" do
    command "gem install resque redis redis-namespace yajl-ruby -r"
    not_if { "gem list | grep resque" }
  end

  case node[:ec2][:instance_type]
  when 'm1.small' then worker_count = 2
  when 'c1.medium'then worker_count = 3
  when 'c1.xlarge' then worker_count = 8
  else worker_count = 4
  end

  redis_instance = node['utility_instances'].find { |instance| instance['name'] == 'redis' }

  node[:applications].each do |app, data|
    template "/etc/monit.d/resque_#{app}.monitrc" do
      owner 'root' 
      group 'root' 
      mode 0644 
      source "monitrc.conf.erb" 
      variables({ 
      :num_workers => worker_count,
      :app_name => app, 
      :rails_env => node[:environment][:framework_env] 
      }) 
    end

    # Used to set the redis hostname for the worker
    template "/data/#{app}/shared/config/resque.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source "resque.yml.erb"
      variables({
        :environment => node[:environment][:framework_env],
        :hostname => redis_instance[:hostname]
      })
    end

    execute "Symlink /data/#{app}/shared/config/resque.yml to /data/#{app}/current/config/resque.yml" do
      command "ln -sf /data/#{app}/shared/config/resque.yml /data/#{app}/current/config/resque.yml"
    end

    worker_count.times do |count|
      template "/data/#{app}/shared/config/resque_#{count}.conf" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        source "resque_wildcard.conf.erb"
      end
    end

    execute "ensure-resque-is-setup-with-monit" do 
      epic_fail true
      command %Q{ 
      monit reload 
      } 
    end
  end 
end
