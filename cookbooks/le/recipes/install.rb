#
# Cookbook Name:: le
# Recipe:: install
#
le_version="1.4.25"

directory "/engineyard/portage/engineyard/dev-util/le" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

remote_file "/engineyard/portage/engineyard/dev-util/le/le-#{le_version}.ebuild" do
  source "le-#{le_version}.ebuild"
  mode "0644"
end

execute "ebuild le-#{le_version}.ebuild digest" do
  command "ebuild le-#{le_version}.ebuild digest"
  cwd "/engineyard/portage/engineyard/dev-util/le/"
  # only_if { `eix dev-util/le -O` =~ /No matches found./ }
end

enable_package 'dev-python/python-exec' do
  version '0.2'
  unmask true
end

package 'dev-python/python-exec' do
  version '0.2'
  action :install
end

package 'dev-util/le' do
  version "#{le_version}"
  action :install
end

# ln -s /usr/bin/le /usr/bin/le-monitordaemon
link "/usr/bin/le-monitordaemon" do
  to "/usr/bin/le"
end

# init.d script for le agent
template '/etc/init.d/logentries' do
  source 'logentries.initd.erb'
  mode '0755'
end

# Start agent when instance boots
execute 'start logentries at boot' do
  command %{rc-update add logentries default}
  creates '/etc/runlevels/default/logentries'
end
