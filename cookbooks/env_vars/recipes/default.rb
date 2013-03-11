#
# Cookbook Name:: env_vars
# Recipe:: default
#

if ['solo', 'app', 'app_master', 'util'].include?(node[:instance_role])
  
  node[:applications].each do |app_name, data|
    template "/data/#{app_name}/shared/config/env.custom" do
      source "env.custom.erb"
      owner node[:users].first[:username]
      group node[:users].first[:username]
      mode 0744
      variables({
          :env_vars => node[:env_vars]
      })
    end
    template "/data/#{app_name}/shared/bin/ruby_wrapper" do
      source "ruby_wrapper.erb"
      owner node[:users].first[:username]
      group node[:users].first[:username]
      mode 0755
      variables({
          :app_name => app_name
      })
    end
    
    case node[:environment][:stack]
    when /nginx_passenger/i
      execute "update-nginx-passenger-ruby" do
        command "echo 'passenger_ruby /data/#{app_name}/shared/bin/ruby_wrapper;' >> /etc/nginx/stack.conf"
        not_if "grep passenger_ruby /etc/nginx/stack.conf"
      end
      execute "reload-nginx" do
        command "/etc/init.d/nginx reload"
      end
    end
    
  end

end