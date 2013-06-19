#
# Cookbook Name:: unicorn_custom
# Recipe:: default
#
Chef::Log.info "Apply custom configuration for unicorn"

if ['app', 'app_master', 'solo'].include? node[:instance_role]

  execute "restart unicorn" do
    command "monit restart unicorn_master_#{app_name}"
    action :nothing
  end

  template "/data/#{app_name}/shared/config/env.custom" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "env_custom"
    notifies :run, resources(:execute => "restart unicorn")
    variables({
      :app_name => app_name
    })
  end

  Chef::Log.info "Applied custom unicorn config to #{node[:instance_role]} instance"
end
