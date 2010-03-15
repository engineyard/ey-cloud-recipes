#
# Cookbook Name:: ruby-heaps-stack
# Recipe:: default
#

remote_file "/usr/src/ruby-heaps-stacks.tar.gz" do
  source "http://github.com/ice799/matzruby/tarball/heap_stacks"
  owner "root"
  group "root"
  mode "0644"
end

execute "unarchive ruby" do
  command "cd /usr/src;tar zxfv ruby-heaps-stacks.tar.gz"
end

execute "autotools" do
  command "cd /usr/src/ice799-matzruby*;autoconf"
end

execute "libtoolize" do
  command "cd /usr/src/ice799-matzruby*;libtoolize --force"
end

execute "autotools round 2" do
  command "cd /usr/src/ice799-matzruby*;autoconf"
end

execute "configure" do
  command "cd /usr/src/ice799-matzruby*;./configure --prefix=/usr --sysconfdir=/etc --enable-pthread --enable-shared"
end

execute "make" do
  command "cd /usr/src/ice799-matzruby*;make -j1"
end

execute "make install" do
  command "cd /usr/src/ice799-matzruby*;make install"
end

remote_file "/usr/src/rubygems.tar.gz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-1.3.6.tgz"
  owner "root"
  gorup "root"
  mode "0644"
end

execute "unarchive rubygems" do
  source "cd /usr/src;tar zxfv rubygems-1.3.6.tgz"
end

execute "install_rubygems" do
  execute "cd /usr/src/rubygems-1.3.6;ruby setup.rb --no-ri --no-rdoc" 
end

