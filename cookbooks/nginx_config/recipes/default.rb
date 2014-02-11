#
# Cookbook Name:: nginx_config
# Recipe:: default
#

if node[:instance_role] == 'solo'

  remote_file "/etc/nginx/servers/examtime/custom.conf" do
    owner "deploy"
    group "deploy"
    mode 0644
    source "custom.conf"
    backup false
    action :create
  end
  
  remote_file "/etc/nginx/servers/examtime/custom.ssl.conf" do
    owner "deploy"
    group "deploy"
    mode 0644
    source "custom.ssl.conf"
    backup false
    action :create
  end
  
  remote_file "/etc/nginx/http-custom.conf" do
    owner "deploy"
    group "deploy"
    mode 0644
    source "http-custom.conf"
    backup false
    action :create
  end
  Chef::Log.info "Nginx configuration deployed" 
end

ey_cloud_report "nginx_config" do 
  message "Nginx configuration deployed" 
end 

