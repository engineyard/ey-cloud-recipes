user = @node[:users].first

if ['db_master','solo'].include? @node[:instance_role]
  #for arbiter purposes
  mongo_data = "/mnt/mongodb/data"
  mongo_log = "/mnt/mongodb/log"
else
  mongo_data = @node[:mongo_base] + "/data"
  mongo_log = @node[:mongo_base] + "/log"
end

mongo_bin_path = @node[:mongo_path] + "/bin"

execute "expand path to include mongo instalation path" do
  command "export PATH=\"$PATH\:#{mongo_bin_path}\""
  not_if "echo $PATH | grep mongo"
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

#---- drop backup yml
template "/etc/.mongodb.backups.yml" do
  owner "root"
  group "root"
  mode 0600
  source "mongodb.backups.yml.erb"
  variables(:config => {
    :dbuser => nil, # not implemented
    :dbpass => nil, # not implemented
    :keep   => node[:backup_window] || 14,
    :id     => node[:aws_secret_id],
    :key    => node[:aws_secret_key],
    :env    => node[:environment][:name],
    :region => node.engineyard.environment.region,
    :backup_bucket => node.engineyard.environment.backup_bucket,
    :databases => {}  #do something here so it backs up the entire thing        
  })
end


#------ teach it how to snapshot itself
# Chef::Log.info "Redefine snapshots for Mongo"
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
