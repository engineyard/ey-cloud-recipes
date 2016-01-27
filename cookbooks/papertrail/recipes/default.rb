#
# Cookbook Name:: papertrail
# Recipe:: default
#
# thanks @indirect !
# Adapted from the original https://github.com/indirect/ey-cloud-recipes/tree/master/cookbooks/papertrail
# and https://github.com/bhoggard/remote_syslog2
#
# This recipe makes EngineYard Gentoo instances send logs to Papertrail (papertrailapp.com).
# * syslog-ng is used to monitor syslog
# * remote_syslog2 is used for other (application, database, etc.) logs
# * TLS is used instead of UDP

app_name = node[:applications].keys.first
env = node[:environment][:framework_env]
PAPERTRAIL_CONFIG = {
  :syslog_ng_version         => '3.3.5-r1',
  :remote_syslog_version     => 'v0.16',
  :remote_syslog_filename    => 'remote_syslog_linux_amd64.tar.gz',
  :remote_syslog_checksum    => '04055643eb1c0db9ec61a67bdfd58697912acb467f58884759a054f6b5d6bb56',
  :port                      => 111111111111111, # YOUR PORT HERE
  :destination_host          => 'HOST.papertrailapp.com', # YOUR HOST HERE
  :hostname                  => [app_name, node[:instance_role], `hostname`.chomp].join('_'),
  :other_logs => [
    '/var/log/engineyard/nginx/*log',
    '/var/log/engineyard/apps/*/*.log',
    '/var/log/mysql/*.log',
    '/var/log/mysql/mysql.err',
  ],
  :exclude_patterns => [
    '400 0 "-" "-" "-', # seen in ssl access logs
  ],
}
remote_syslog_src_filename = PAPERTRAIL_CONFIG[:remote_syslog_filename]
remote_syslog_src_filepath = "#{Chef::Config['file_cache_path']}#{remote_syslog_src_filename}"
remote_syslog_extract_path = "#{Chef::Config['file_cache_path']}remote_syslog2/#{PAPERTRAIL_CONFIG[:remote_syslog_checksum]}"

# install syslog-ng

# EngineYard Gentoo Portage only recently added a new version of syslog-ng, so you have to update it even on new instances
execute 'get-latest-portage' do
  command 'emerge --sync'
end

# Make sure you have the EngineYard "enable_package" recipe
enable_package 'app-admin/syslog-ng' do
  version PAPERTRAIL_CONFIG[:syslog_ng_version]
  override_hardmask true
end

package 'app-admin/syslog-ng' do
  version PAPERTRAIL_CONFIG[:syslog_ng_version]
  action :install
end

directory '/etc/syslog-ng/cert.d' do
  recursive true
end

remote_file '/etc/syslog-ng/cert.d/papertrail-bundle.tar.gz' do
  source 'https://papertrailapp.com/tools/papertrail-bundle.tar.gz'
  checksum '5590de7f7f957508eff58767212cae8fa2fb8cf503e5b5b801f32087501060f3'
  mode '0644'
end

bash 'extract SSL certificates' do
  cwd '/etc/syslog-ng/cert.d'
  code <<-EOH
    tar xzf papertrail-bundle.tar.gz
    EOH
end

service "syslog-ng" do
    supports :start => true, :stop => true, :restart => true, :status => true
    action [ :enable, :start ]
end

template '/etc/syslog-ng/syslog-ng.conf' do
  source 'syslog-ng.conf.erb'
  mode '0644'
  variables(PAPERTRAIL_CONFIG)
  notifies :restart, resources(:service => "syslog-ng")
end

# EngineYard Gentoo instances use sysklogd by default
execute 'stop-sysklogd' do
  command %{/etc/init.d/sysklogd stop}
  ignore_failure true
end

execute 'restart-syslog-ng' do
  command %{/etc/init.d/syslog-ng restart}
end

# remove remote_syslog gem & install remote_syslog2 daemon

execute 'stop existing instances of remote_syslog' do
  command %{/etc/init.d/remote_syslog stop}
  only_if { ::File.exists?("/etc/init.d/remote_syslog") }
end

execute 'remove remote_syslog gem' do
  command %{gem uninstall remote_syslog -x}
end

execute "Get remote_syslog" do
  command "wget -O #{remote_syslog_src_filepath} https://github.com/papertrail/remote_syslog2/releases/download/#{PAPERTRAIL_CONFIG[:remote_syslog_version]}/#{PAPERTRAIL_CONFIG[:remote_syslog_filename]}"
end

bash 'extract and copy executable' do
  cwd ::File.dirname(remote_syslog_src_filepath)
  code <<-EOH
    mkdir -p #{remote_syslog_extract_path}
    tar xzf #{remote_syslog_src_filename} -C #{remote_syslog_extract_path}
    mv #{remote_syslog_extract_path}/remote_syslog/remote_syslog /usr/local/bin
    EOH
  not_if { ::File.exists?(remote_syslog_extract_path) }
end

file "/usr/local/bin/remote_syslog" do
  owner "root"
  group "root"
  mode "0755"
  action :touch
end

# remote_syslog config file
template '/etc/log_files.yml' do
  source 'log_files.yml.erb'
  mode '0644'
  variables(PAPERTRAIL_CONFIG)
end

# init.d config file
template '/etc/conf.d/remote_syslog' do
  source 'remote_syslog.confd.erb'
  mode '0644'
end

# init.d script
template '/etc/init.d/remote_syslog' do
  source 'remote_syslog.initd.erb'
  mode '0755'
end

# start at boot
execute 'start remote_syslog at boot' do
  command %{rc-update add remote_syslog default}
  creates '/etc/runlevels/default/remote_syslog'
end

# start right now
execute 'start or restart remote_syslog' do
  command %{/etc/init.d/remote_syslog restart}
end
