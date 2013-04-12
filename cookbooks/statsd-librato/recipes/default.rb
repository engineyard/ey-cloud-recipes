#
# Cookbook Name:: statsd-librato
# Recipe:: default
#

# Set your Librato credentials
librato_email = "you@example.com"
librato_token = "your-token-goes-here"

# Set your app name
app_name = "your-app-name-goes-here"

# Set install dir for statsd
src_dir = "/usr/lib/statsd"

statsd_port = 8126

statsd_enabled_env = ['production'].include?(node[:environment][:framework_env])
statsd_enabled_instance = ['app_master', 'app'].include?(node[:instance_role])

if statsd_enabled_env && statsd_enabled_instance
  execute "install statsd" do
    command "git clone git://github.com/etsy/statsd.git"
    cwd "/usr/lib"
    not_if { File.exists?("#{src_dir}/.git/")}
    user "root"
  end

  execute "install statsd-librato-backend" do
    command "npm install statsd-librato-backend"
    cwd "/usr/lib/statsd"
    not_if { File.exists?("#{src_dir}/node_modules/statsd-librato-backend/package.json")}
    user "root"
  end

  template "/data/#{app_name}/shared/config/statsd.js" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "config.js.erb"
    variables({
      :statsd_port => port,
      :librato_email => librato_email,
      :librato_token => librato_token
    })
  end

  template "/data/#{app_name}/shared/statsd" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0744
    source "statsd.erb"
    variables({
      :src_dir => src_dir,
      :app_name => app_name
    })
  end

  template "/etc/monit.d/statsd.monitrc" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "monitrc.conf.erb"
    variables({
      :user => node[:owner_name],
      :app_name => app_name
    })
  end

  execute "monit reload" do
    action :run
  end
end
