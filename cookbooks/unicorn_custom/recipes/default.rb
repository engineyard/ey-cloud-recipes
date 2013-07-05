#
# Cookbook Name:: unicorn_custom
# Recipe:: default
#
class ExamTimeWebWorkersStrategy
  def self.workers_count(node)
    return 0 unless %w(solo app_master app).include?(node[:instance_role])
    case node[:ec2][:instance_type]
      when 'c1.medium'
        return 10
      when 'c1.xlarge'
        return 20
      else
        return 2
    end
  end
end

node[:applications].each do |app_name, data|
  Chef::Log.info "Apply custom configuration for unicorn on #{app_name}"

  if ['app', 'app_master', 'solo'].include? node[:instance_role]

    execute "restart unicorn" do
      command "monit restart unicorn_master_#{app_name}"
      action :nothing
    end

    template "/data/#{app_name}/shared_config/unicorn_custom.rb" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source "unicorn_custom.erb"
      notifies :run, resources(:execute => "restart unicorn")
      variables({
        :app_name => app_name,
        :workers_count => ExamTimeWebWorkersStrategy.workers_count(node)
      })
    end

    template "/data/#{app_name}/shared/config/env.custom" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source "env_custom.erb"
      notifies :run, resources(:execute => "restart unicorn")
      variables({
        :app_name => app_name
      })
    end

    Chef::Log.info "Applied custom unicorn config to #{node[:instance_role]} instance"
  end
end
