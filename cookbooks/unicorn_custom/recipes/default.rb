#
# Cookbook Name:: unicorn_custom
# Recipe:: default
#
ey_cloud_report "unicorn_custom" do 
  message "Apply custom configuration for unicorn on"
end

if ['app', 'app_master'].include? node[:instance_role]

  ey_cloud_report "unicorn_custom" do 
    message "Applying to #{node[:instance_role]}"
  end
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
