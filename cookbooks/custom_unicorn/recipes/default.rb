#
# Cookbook Name:: custom_unicorn
# Recipe:: default
#
if ['app', 'app_master'].include? node[:instance_role]
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
end
