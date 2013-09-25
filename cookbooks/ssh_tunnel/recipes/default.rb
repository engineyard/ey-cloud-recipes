#
# Cookbook Name:: ssh_tunnel
# Recipe:: default
#

# set this to match on the node[:instance_role] of the instance the tunnel
# should be set up on
if node[:instance_role] == node['ssh_tunnel']['instance_role']

  template "/etc/init.d/#{node['ssh_tunnel']['tunnel_name']}" do
    source "ssh_tunnel.initd.erb"
    owner 'root'
    group 'root'
    mode 0755
  end
  
  template "/etc/monit.d/#{node['ssh_tunnel']['tunnel_name']}.monitrc" do
    source "ssh_tunnel.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
  end
  
  execute "monit quit" do
    action :nothing
    subscribes :run, "template[/etc/monit.d/#{tunnel_name}.monitrc]", :immediately
  end
end