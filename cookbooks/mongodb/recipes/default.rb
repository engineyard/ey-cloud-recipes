#
# Cookbook Name:: mongodb
# Recipe:: default


directory "/data/master" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?('/data/master') }
end

# The recipe is not using a slave yet but it will create the directory
# so that it is there for the future
directory "/data/slave" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?('/data/slave') }
end
  
execute "install-mongodb" do
  command %Q{
    curl -O http://downloads.mongodb.org/linux/mongodb-linux-x86_64-1.0.0.tgz &&
    tar zxvf mongodb-linux-x86_64-1.0.0.tgz &&
    mv mongodb-linux-x86_64-1.0.0 /usr/local/mongodb &&
    rm mongodb-linux-x86_64-1.0.0.tgz
  }
  not_if { File.directory?('/usr/local/mongodb') }
end
  
execute "add-to-path" do
  command %Q{
    echo 'export PATH=$PATH:/usr/local/mongodb/bin' >> /etc/profile
  }
  not_if "grep 'export PATH=$PATH:/usr/local/mongodb/bin' /etc/profile"
end
  
remote_file "/etc/init.d/mongodb" do
  source "mongodb"
  owner "root"
  group "root"
  mode 0755
end

execute "add-mongodb-to-default-run-level" do
  command %Q{
    rc-update add mongodb default
  }
  not_if "rc-status | grep mongodb"
end

execute "ensure-mongodb-is-running" do
  command %Q{
    /etc/init.d/mongodb start
  }
  not_if "pgrep mongod"
end



