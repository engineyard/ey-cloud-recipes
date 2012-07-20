#
# Cookbook Name:: papertrail
# Recipe:: default
#
# thanks @indirect !
# Adapted from the original https://github.com/indirect/ey-cloud-recipes/tree/master/cookbooks/papertrail
#
# This recipe makes EngineYard Gentoo instances send logs to Papertrail (papertrailapp.com).
# * syslog-ng is used to monitor syslog
# * remote_syslog is used for other (application, database, etc.) logs
# * TLS is used instead of UDP

app_name = node[:applications].keys.first
env = node[:environment][:framework_env]
PAPERTRAIL_CONFIG = {
  :syslog_ng_version         => '3.3.5',
  :remote_syslog_gem_version => '~>1.6',
  :port                      => 11111111111111, # YOUR PORT HERE
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

remote_file '/etc/syslog.papertrail.crt' do
  source 'https://papertrailapp.com/tools/syslog.papertrail.crt'
  checksum '7d6bdd1c00343f6fe3b21db8ccc81e8cd1182c5039438485acac4d98f314fe10'
  mode '0644'
end

directory '/etc/syslog-ng/cert.d' do
  recursive true
end

link '/etc/syslog-ng/cert.d/2f2c2f7c.0' do
  to '/etc/syslog.papertrail.crt'
  link_type :symbolic
end

template '/etc/syslog-ng/syslog-ng.conf' do
  source 'syslog-ng.conf.erb'
  mode '0644'
  variables(PAPERTRAIL_CONFIG)
end

# EngineYard Gentoo instances use sysklogd by default
execute 'stop-sysklogd' do
  command %{/etc/init.d/sysklogd stop}
  ignore_failure true
end

execute 'restart-syslog-ng' do
  command %{/etc/init.d/syslog-ng restart}
end

# install remote_syslog daemon

execute 'install remote_syslog gem' do
  command %{gem install remote_syslog -v '#{PAPERTRAIL_CONFIG[:remote_syslog_gem_version]}'}
  creates '/usr/bin/remote_syslog'
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
