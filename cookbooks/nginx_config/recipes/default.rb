#
# Cookbook Name:: nginx_config
# Recipe:: default
#

if node[:instance_role] == 'solo'

  template "/etc/nginx/servers/examtime/custom.conf" do
 #   owner node[:owner_name]
 #   group node[:owner_name]
    owner "deploy"
    group "deploy"
    mode 0644
    source "custom.erb"
    if node[:instance_role] == 'solo'
    variables({
                :auth_basic => 'auth_basic "ExamTime integration - Company Confidential - this site is restricted to ExamTime staff only";',
                :auth_basic_user_file => "auth_basic_user_file /data/nginx/servers/examtime/examtime.users;",

              })
      end
  end

  # remote_file "/etc/nginx/servers/examtime/custom.conf" do
  #   owner "deploy"
  #   group "deploy"
  #   mode 0644
  #   source "custom.conf"
  #   backup false
  #   action :create
  # end
  
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

