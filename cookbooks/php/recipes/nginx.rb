#
# Cookbook Name:: php
# Recipe:: nginx
#

node['applications'].each do |app_name, data|
  if ['app_master', 'app', 'solo'].include?(node['instance_role'])
    # Update the Nginx root path based on the application
    execute "update Nginx root path" do
      # The following assume the index path for your app is /public.
      # You will need to modify this if the path is different, ie: /app/webroot
      command "sed -i -e 's_/data/#{app_name}/current;_/data/#{app_name}/current/app/webroot;_' /data/nginx/servers/#{app_name}.conf"
      action :run
    end
  
    # Restart Nginx so new configuration will take effect
    service "nginx" do
      action :restart
    end
  end
end