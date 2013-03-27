#
# Cookbook Name:: block
# Recipe:: default
#

# setup fail2ban
require_recipe "block::fail2ban"

# block ips
block do
  ip "128.23.83.192"
  ip "243.123.123.123", :ports => [22, 80, 443]
end
