#
# Cookbook Name:: collectd-custom
# Recipe:: default
#

attributes = node['collectd-custom']
service = "service[#{attributes['service_name']}]"
config_opts = []

# Emerge required packages
attributes['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

# Download source
remote_file "#{Chef::Config[:file_cache_path]}/collectd-#{attributes['version']}.tar.gz" do
  source attributes['source_url']
  checksum attributes['checksum']
  action :create_if_missing
end

# prefix
config_opts << "--prefix=#{attributes['dir']}"

# platform specific
case node['platform_family']
when 'gentoo'
  config_opts << "--without-included-ltdl"
  config_opts << "--with-libiptc=no" unless attributes['plugins'].include? 'iptables'
end

# Compile
bash "install-collectd" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    [ -d collectd-#{attributes['version']}/ ] || mkdir collectd-#{attributes['version']}/
    tar -xzf collectd-#{attributes['version']}.tar.gz -C collectd-#{attributes['version']}/ --strip 1
    cd collectd-#{attributes['version']}
    export EPYTHON="python2.7"
    ./configure #{config_opts.join(" ")}
    make && make install
  EOH
  not_if "#{attributes['dir']}/sbin/collectd -h 2>&1 | grep #{attributes['version']}"
end

# Create init.d
template "/etc/init.d/#{attributes['service_name']}" do
  owner 'root'
  group 'root'
  mode 0766
  source 'collectd.init.erb'
  variables({
    :dir => attributes['dir'],
    :pid_file => attributes['pid_file'],
    :pid_dir => File.dirname(attributes['pid_file']),
    :user => attributes['user']
  })
  notifies :restart, "service[#{attributes['service_name']}]"
end

# Create custom config directory under EY mount
directory "/data/collectd.d" do
  owner attributes['user']
  group attributes['user']
  mode 0755
  action :create
end

link "#{attributes['dir']}/etc/conf.d" do
  to "/data/collectd.d"
end

# Create the logfile if that's configured
if attributes['plugins'].keys.include?('logfile')
  logfile_config = attributes['plugins']['logfile']['config']
  logfile_dir = File.dirname(logfile_config['File'])

  directory logfile_dir do
    owner attributes['user']
    group attributes['user']
    mode 0755
    recursive true
    not_if "[ -d #{logfile_dir} ]"
  end

  file logfile_config['File'] do
    owner attributes['user']
    group attributes['user']
    mode 0644
    action :create_if_missing
  end

  template "/etc/logrotate.d/#{attributes['service_name']}" do
    owner 'root'
    group 'root'
    mode 0644
    source 'logrotate.conf.erb'
    variables({
      :log_file => logfile_config['File'],
      :rotate => 7
    })
  end
end

# Create the base configuration
template "#{attributes['dir']}/etc/collectd.conf" do
  mode "0644"
  source "collectd.conf.erb"
  variables({
    :hostname     => attributes['hostname'],
    :pid_file     => attributes['pid_file'],
    :dir          => attributes['dir'],
    :interval     => attributes['interval'],
    :read_threads => attributes['read_threads'],
    :plugins      => attributes['plugins']
  })
  notifies :restart, "service[#{attributes['service_name']}]"
end

# Configure plugins provided by DNA
include_recipe "collectd-custom::plugins"

# Start collectd-custom
service attributes['service_name'] do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
