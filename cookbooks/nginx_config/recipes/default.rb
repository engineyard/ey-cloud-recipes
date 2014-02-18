#
# Cookbook Name:: nginx_config
# Recipe:: default
#

if %( app_master app solo ).include?(node[:instance_role])

  template "/etc/nginx/servers/examtime/custom.conf" do
    owner "deploy"
    group "deploy"
    mode 0644
    source "custom.erb"
    if environment[:name]!='production'
      variables({
        :auth_basic => 'auth_basic "ExamTime integration - Company Confidential - this site is restricted to ExamTime staff only";',
	:auth_basic_user_file => "auth_basic_user_file /data/nginx/servers/examtime/examtime.users;",
      })
    end
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

