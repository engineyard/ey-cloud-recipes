
if ['app_master','solo'].include? @node[:instance_role] then
  include_recipe "jenkins::jetty_install"
  include_recipe "jenkins::jenkins_install"
end

if "app_master" == @node[:instance_role] then
  execute "touch /etc/keep.haproxy.cfg" do
    action :run
  end
  remote_file "/etc/haproxy.cfg" do
    source "haproxy.cfg"
    action :create
  end
  
  execute "Restart HAProxy" do
    command "sudo /etc/init.d/haproxy reload"
  end
   
end

if "solo" == @node[:instance_role] then
  remote_file "/etc/nginx/servers/jetty.conf" do
    source "nginx.jetty.conf"
  end 
end

if @node[:instance_role] == 'util' then
  include_recipe "jenkins::swarm_install"
end
