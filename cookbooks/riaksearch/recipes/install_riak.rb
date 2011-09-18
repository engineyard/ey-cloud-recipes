# Installer stuff here
#

# Riaksearch dependency here.
package "dev-java/ant" do
  version '1.7.0'
  action :install
end

remote_file "/mnt/src/riak_search-#{node[:riaksearch][:version]}.tar.gz" do
  source "http://downloads.basho.com/riak-search/CURRENT/riak_search-#{node[:riaksearch][:version]}.tar.gz"
  backup 0
  not_if { FileTest.exists?("/mnt/src/riak_search-#{node[:riaksearch][:version]}.tar.gz") }
end

execute "untar riak" do
  command "cd /mnt/src;tar zxf riak_search-#{node[:riaksearch][:version]}.tar.gz"
  not_if { FileTest.directory?("/mnt/src/riak_search-#{node[:riaksearch][:version]}") }
end

execute "make all rel" do
  command "cd /mnt/src/riak_search-#{node[:riaksearch][:version]};make all rel && cp -prv rel/riaksearch /data/riak_search"
  not_if { FileTest.exists?("/data/riak_search/bin/riaksearch") }
end
