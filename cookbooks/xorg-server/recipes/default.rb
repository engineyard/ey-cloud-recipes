#
# Cookbook Name:: xorg-server
# Recipe:: default
#
require_recipe 'xorg-server::install'

template "/engineyard/bin/xvfb-run" do
  owner 'root'
  group 'root'
  mode '0755'
  source "xvfb-run.erb"
end


if ( %w(solo app_master app).include?(node[:instance_role]) || (node[:instance_role] == 'util' && node[:name] !~ /^(mongodb|redis|memcache)/) )
  
  template "/etc/init.d/xvfb" do
    source "xvfb.initd.erb"
    owner 'root'
    group 'root'
    mode 0755
  end

  node[:applications].each do |app_name,data|

    template "/etc/monit.d/#{app_name}_xvfb.monitrc" do
      source "xvfb.monitrc.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        :app_name => app_name,
        :app_dir => "/data/#{app_name}/current",
        :pid_dir => "/data/#{app_name}/current/tmp/pids",
        :user => node[:owner_name],
        :timeout => 240, # seconds
        :framework_env => node[:environment][:framework_env]
      })
    end

    execute "monit reload" do
       action :run
       epic_fail true
    end

  end

end
