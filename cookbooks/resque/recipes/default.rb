#
# Cookbook Name:: resque
# Recipe:: default

if (['util'].include?(node[:instance_role]) && node[:name] =~ /^worker/i) || node[:instance_role] == 'solo'

  execute "install resque gem" do
    command "gem install resque redis redis-namespace yajl-ruby -r"
    not_if { "gem list | grep resque" }
  end

  # Self shutdown check for graceful restarts
  template "/engineyard/bin/worker-shutdown-check" do
    owner  "root"
    group  "root"
    mode   "0755"
    source "worker-shutdown-check.erb"
    action :create
  end

  cron "run_worker_shutdown_check" do
    hour    "*"
    minute  "*"
    command "/engineyard/bin/worker-shutdown-check"
  end

  redis_instance = node['utility_instances'].find { |instance| instance['name'] == 'redis' }

  node[:applications].reject{ |app, _| app != 'dynamiccreative' }.each do |app, data|
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

    # Find what queue group or queue this worker is configured to use (based on the name)
    node[:name].scan(/worker_([a-z_]*)_[0-9]*/i) do |worker_class|

      # Determine the array of workers dependent on the queue identifier provided
      key     = worker_class[0]
      queues  = node[:queues]
      workers = [ key ] * 8   # Fallback

      if queues.has_key?(key) || key.nil?
        workers = queues[:all].values.map { |v| v.values }.flatten
      else
        queues[:all].each do |(group, subgroups)|
          if group == key
            workers = subgroups.values.flatten
            break
          end
        subgroups.each do |(subgroup, queues)|
          if subgroup == key
            workers = queues
            break
          end
        end
        end
      end

      workers.each_with_index do |queue, index|
        template "/data/#{app}/shared/config/resque_#{index}.conf" do
          owner node[:owner_name]
          group node[:owner_name]
          mode 0644
          variables({:queue => queue})
          source "resque_wildcard.conf.erb"
        end
      end

      template "/etc/monit.d/resque_#{app}.monitrc" do
        owner 'root'
        group 'root'
        mode 0644
        source "monitrc.conf.erb"
        variables({
          :num_workers => workers.size,
          :app_name => app,
          :rails_env => node[:environment][:framework_env]
        })
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
