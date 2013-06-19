#
# Cookbook Name:: unicorn_custom
# Recipe:: default
#
node[:applications].each do |app_name, data|
  Chef::Log.info "Apply custom configuration for unicorn on #{app_name}"

  if ['app', 'app_master', 'solo'].include? node[:instance_role]

    execute "restart unicorn" do
      command "monit restart unicorn_master_#{app_name}"
      action :nothing
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
