user = @node[:users].first

if ['db_master','solo'].include? @node[:instance_role]
  #for arbiter purposes
  mongo_data = "/mnt/mongodb/data"
  mongo_log = "/mnt/mongodb/log"
else
  mongo_data = @node[:mongo_base] + "/data"
  mongo_log = @node[:mongo_base] + "/log"
end

directory mongo_data do
  owner user[:username]
  group user[:username]
  mode  '0755'
  action :create
  recursive true
end

directory mongo_log do
  owner user[:username]
  group user[:username]
  mode '0755'
  action :create
  recursive true
end

directory '/var/run/mongodb' do
  owner user[:username]
  group user[:username]
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

mongodb_options = { :exec => "#{@node[:mongo_path]}/bin/mongod",
                    :data_path => mongo_data,
                    :log_path => mongo_log,
                    :user => user[:username],
                    :pid_path => "/var/run/mongodb",
                    :ip => "0.0.0.0",
                    :port => @node[:mongo_port],
                    :extra_opts => [] }
if @node[:mongo_journaling]
  mongodb_options[:extra_opts]  << "--journal"
end

if @node[:mongo_replset]
  mongodb_options[:extra_opts]  << "--replSet #{@node[:mongo_replset]}"
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

remote_file "/etc/init.d/mongodb" do
  source "mongodb.init"
  owner "root"
  group "root"
  mode 0755
  backup false
  action :create
end

# Know how to snapshot itself

Chef::Log.info "Redefine snapshots for Mongo"
partition    = "data"
service_name = "mongo"
dbpath = "/#{partition}/mongodb/#{service_name}/"

execute "remove-mongodb-snapshot-key-lock-file" do
  command "if [ -f /#{partition}/mongodb/#{service_name}/mongod.lock.key ]; then rm -f /#{partition}/mongodb/#{service_name}/mongod.lock.key /#{partition}/mongodb/#{service_name}/mongod.lock; fi"
  not_if "pgrep mongod"
end

template "/usr/local/bin/ey-snapshots-with-mongodb" do
  source "ey-snapshots-with-mongodb.erb"
  cookbook 'mongodb'
  owner 'root'
  group 'root'
  mode '0755'
end

remote_file "/root/.bash_profile" do
  source "root.bash_profile"
  cookbook 'mongodb'
  owner 'root'
  group 'root'
  mode '0600'
end
