#
# Cookbook Name:: mongodb
# Recipe:: default
#

if node[:instance_role] == 'util' && node[:name].match(/^mongodb_/)

  # If using masterslave to replicate from a remote master, this
  # requires a tunnel to be created and running on port 27027
  remote_master     = 'localhost:27027'
  local_master      = 'localhost'
  
  node[:utility_instances].each do |util_instance|
    if util_instance[:name].match(/(master|masterslave)$/)
      local_master = util_instance[:hostname]
    end
  end
  
  mongodb_options = "--master" if node[:name].match(/master$/)
  mongodb_options = "--master --slave --source=#{remote_master}" if node[:name].match(/masterslave$/)
  mongodb_options = "--slave --source=#{local_master}" if node[:name].match(/slave(\d*)$/)  
  
  package "dev-db/mongodb-bin" do
    action :install
  end
  
  directory '/data/mongodb/data' do
    owner 'mongodb'
    group 'mongodb'
    mode  '0755'
    action :create
    recursive true
  end

  directory '/data/mongodb/log' do
    owner 'mongodb'
    group 'mongodb'
    mode '0755'
    action :create
    recursive true
  end
  
  directory '/var/run/mongodb' do
    owner 'mongodb'
    group 'mongodb'
    mode '0755'
    action :create
    recursive true
  end  
  
  remote_file "/etc/logrotate.d/mongodb" do
    owner "root"
    group "root"
    mode 0755
    source "mongodb.logrotate"
    backup false
    action :create
  end
  
  template "/etc/conf.d/mongodb" do
    source "mongodb.conf.erb"
    owner "root"
    group "root"
    mode 0755
    variables({
      :mongodb_options => mongodb_options
    })
  end  
  
  execute "enable-mongodb" do
    command "rc-update add mongodb default"
    action :run
  end  
  
  execute "start-mongodb" do
    command "/etc/init.d/mongodb restart"
    action :run
    not_if "/etc/init.d/mongodb status"
  end  
  
  node[:applications].each do |app_name,data|
    user = node[:users].first
    db_name = "#{app_name}_#{node[:environment][:framework_env]}"
    
    execute "create-mongodb-root-user" do
      command "/usr/bin/mongo admin --eval 'db.addUser(\"root\",\"#{user[:password]}\")'"
      action :run
      not_if "/usr/bin/mongo admin --eval 'db.auth(\"root\",\"#{user[:password]}\")' | grep -q ^1$"
    end    
    
    execute "create-mongodb-replication-user" do
      command "/usr/bin/mongo admin --eval 'db.auth(\"root\",\"#{user[:password]}\"); db.getMongo().getDB(\"local\").addUser(\"repl\",\"#{user[:password]}\")'"      
      action :run
      not_if "/usr/bin/mongo local --eval 'db.auth(\"repl\",\"#{user[:password]}\")' | grep -q ^1$"      
    end

    execute "create-mongodb-application-users" do
      command "/usr/bin/mongo admin --eval 'db.auth(\"root\",\"#{user[:password]}\"); db.getMongo().getDB(\"#{db_name}\").addUser(\"#{user[:username]}\",\"#{user[:password]}\")'"      
      action :run
      not_if "/usr/bin/mongo #{db_name} --eval 'db.auth(\"#{user[:username]}\",\"#{user[:password]}\")' | grep -q ^1$"
    end    
  end
end