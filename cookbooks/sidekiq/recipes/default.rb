#
# Cookbook Name:: sidekiq
# Recipe:: default
#

# worker count
worker_count = node[:sidekiq_workers].to_i

# install on solo or utility if present
on_solo_or_utility(node[:sidekiq_utility_name]) do
  # report to dashboard
  ey_cloud_report "sidekiq" do
    message "Setting up sidekiq"
  end
  
  # loop through applications
  applications.each do |app_name, data|
    # monit
    template "/etc/monit.d/sidekiq_#{app_name}.monitrc" do 
      mode 0644 
      source "sidekiq.monitrc.erb" 
      variables({ 
        :num_workers => worker_count,
        :app_name => app_name, 
        :rails_env => framework_env
      })
      notifies :run, resources(:execute => 'sidekiq-reload-monit') 
    end

    # bin script
    template "/engineyard/bin/sidekiq" do
      mode 0755
      source "sidekiq.erb" 
      notifies :run, resources(:execute => 'sidekiq-reload-monit') 
    end

    # yml files
    worker_count.times do |count|
      template "/data/#{app_name}/shared/config/sidekiq_#{count}.yml" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        source "sidekiq.yml.erb"
        variables({
          :require => "/data/#{app_name}/current"
        })
        notifies :run, resources(:execute => 'sidekiq-reload-monit') 
      end
    end

    # reload monit
    execute "sidekiq-reload-monit" do
      command "monit reload && sleep 2 && monit restart all -g #{app_name}_sidekiq"
      action :nothing
    end
  end 
end