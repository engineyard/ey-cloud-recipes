#
# Cookbook Name:: resque-scheduler
# Recipe:: default
#
if ['solo', 'util'].include?(node[:instance_role])
  execute "install resque gem" do
    command "gem install resque redis redis-namespace yajl-ruby -r"
    not_if { "gem list | grep resque" }
  end

  node[:applications].each do |app, data|
    template "/etc/monit.d/resque_scheduler_#{app}.monitrc" do
      owner 'root'
      group 'root'
      mode 0644
      source "resque-scheduler.monitrc.erb"
      variables({
      :app_name => app,
      :rails_env => node[:environment][:framework_env]
      })
    end

    remote_file "/data/#{app}/shared/bin/resque-scheduler" do
      source "resque-scheduler"
      owner 'root'
      group 'root'
      mode 0755
      backup 0
    end
  end

  execute "ensure-resque-is-setup-with-monit" do
    command %Q{
    monit reload
    }
  end
end
