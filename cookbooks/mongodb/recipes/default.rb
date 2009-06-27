#
# Cookbook Name:: mongodb
# Recipe:: default

USER = "grocio"

directory "/data/db" do
  owner USER
  group USER
  mode 0755
  recursive true
end
  
execute "install-mongodb" do
  command %Q{
    curl -O http://downloads.mongodb.org/linux/mongodb-linux-i686-0.9.5.tgz &&
    tar zxvf mongodb-linux-i686-0.9.5.tgz &&
    mv mongodb-linux-i686-0.9.5 /usr/local/mongodb &&
    rm mongodb-linux-i686-0.9.5.tgz
  }
  not_if { File.directory?('/usr/local/mongodb') }
end
  
execute "add-to-path" do
  command %Q{
    echo 'export PATH=$PATH:/usr/local/mongodb/bin' >> /etc/profile
  }
  not_if "grep 'export PATH=$PATH:/usr/local/mongodb/bin' /etc/profile"
end
  
execute "install-mongomapper" do
  command %Q{
    gem install jnunemaker-mongomapper --source http://gems.github.com
  }
end
  
execute "start-mongodb" do
  command %Q{
    mongod run 
  }
  not_if "pgrep mongod"
end  


