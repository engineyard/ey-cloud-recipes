#
# Cookbook Name:: libmysql
# Recipe:: default
#
install_path = '/usr/lib64/libmysqlclient_r.so.15'

if ['solo','app','app_master'].include?(node[:instance_role])
  ey_cloud_report "downloading libmysql" do
    message "downloading libmysql"
  end
end

execute "download-libmysql" do
  command 'wget -O /usr/lib64/libmysqlclient.so.15 https://dl.dropbox.com/u/9398197/libmysqlclient_r.so.15'
  command 'chmod 755 /usr/lib64/libmysqlclient.so.15'
end

service "php-fpm" do
  :restart
end