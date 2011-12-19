# Installer stuff here
#

package "dev-java/ant" do
  version '1.7.0'
  action :install
end

remote_file "/mnt/src/riak-#{node[:riak][:version]}.tar.gz" do
  source "http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/CURRENT/riak-#{node[:riak][:version]}.tar.gz"
  backup 0
  not_if { FileTest.exists?("/mnt/src/riak-#{node[:riak][:version]}.tar.gz") }
end

execute "untar riak" do
  command "cd /mnt/src;tar zxf riak-#{node[:riak][:version]}.tar.gz"
  not_if { FileTest.directory?("/mnt/src/riak-#{node[:riak][:version]}") }
end

execute "make all rel" do
  command "cd /mnt/src/riak-#{node[:riak][:version]};make all rel && cp -prv rel/riak /data/riak"
  not_if { FileTest.exists?("/data/riak/bin/riak") }
end
