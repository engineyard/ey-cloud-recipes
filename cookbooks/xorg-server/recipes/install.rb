#
# Cookbook Name:: xorg-server
# Recipe:: install
#

# enable_package 'x11-base/xorg-server' do
#   version node[:xorg_server_version]
# end

package 'x11-base/xorg-server' do
  version node[:xorg_server_version]
  action :install
end
