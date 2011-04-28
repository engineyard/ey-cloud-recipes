postgres_version = '9.0'
postgres_root    = '/db/postgresql'
postgres_oldversion = '8.3'

execute "set_kernel.shmmax" do
  command "sysctl -w kernel.shmmax=#{@node[:total_memory]}"
end

service "postgresql-8.3" do
  case node[:platform]
    when "gentoo"
      service_name "postgresql-8.3"
    else
      service_name "postgresql-8.3"
    end
  supports :restart => true, :reload => true, :status => true
  action [ :disable,:stop ] 
end

service "postgresql-9.0" do
  case node[:platform]
    when "gentoo"
      service_name "postgresql-9.0"
    else
      service_name "postgresql-9.0"
    end
  supports :restart => true, :reload => true, :status => true
  action :nothing
end

execute "activate_postgres_9" do
  command "eselect postgresql set 9.0" 
  action :run
end

directory "#{postgres_root}/#{postgres_version}" do
  owner "postgres"
  group "postgres"
  mode "0755"
  action :create
  recursive true
end

directory "/var/run/postgresql" do
  owner "postgres"
  group "postgres"
  mode "0755"
  action :create
  recursive true
end

remote_file "/etc/conf.d/postgresql-#{postgres_version}" do
  source "#{postgres_version}/postgresql.conf"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

execute "init-postgres" do
 command "initdb -D #{postgres_root}/#{postgres_version}/data --encoding=UTF8 --locale=en_US.UTF-8"
 action :run
 user "postgres"
 not_if { FileTest.directory?("#{postgres_root}/#{postgres_version}/data") }
end

if ['db_master'].include?(node[:instance_role])
  template "#{postgres_root}/#{postgres_version}/data/postgresql.conf" do
    source "#{postgres_version}/postgresql.conf.erb"
    owner "postgres"
    group "root"
    mode 0600
    backup 0
    notifies :restart, resources(:service => "postgresql-#{postgres_version}")
    variables(
      :sysctl_shared_buffers => node[:sysctl_shared_buffers],
      :shared_buffers => node[:shared_buffers],
      :maintenance_work_mem => node[:maintenance_work_mem],
      :work_mem => node[:work_mem],
      :max_stack_depth => "6MB", # not large enough for 8? updating limits would do it but that's the AMI and I don't want to dance with ulimit -s to work around it.
      :effective_cache_size => node[:effective_cache_size],
      :default_statistics_target => node[:default_statistics_target],
      :logging_collector => node[:logging_collector],
      :log_rotation_age => node[:log_rotation_age],
      :log_rotation_size => node[:log_rotation_size],
      :checkpoint_timeout => node[:checkpoint_timeout],
      :checkpoint_segments => node[:checkpoint_segments],
      :wal_buffers => node[:wal_buffers],
      :wal_writer_delay => node[:wal_writer_delay],
      :postgres_root => postgres_root,
      :postgres_version => postgres_version,
      :hot_standby => "off"
    )
  end
end

if ['db_slave'].include?(node[:instance_role])
    template "#{postgres_root}/#{postgres_version}/data/postgresql.conf" do
    source "#{postgres_version}/postgresql.conf.erb"
    owner "postgres"
    group "root"
    mode 0600
    backup 0
    notifies :restart, resources(:service => "postgresql-#{postgres_version}")
    variables(
      :sysctl_shared_buffers => node[:sysctl_shared_buffers],
      :shared_buffers => node[:shared_buffers],
      :maintenance_work_mem => node[:maintenance_work_mem],
      :work_mem => node[:work_mem],
      :max_stack_depth => "6MB", # not large enough for 8? updating limits would do it but that's the AMI and I don't want to dance with ulimit -s to work around it.
      :effective_cache_size => node[:effective_cache_size],
      :default_statistics_target => node[:default_statistics_target],
      :logging_collector => node[:logging_collector],
      :log_rotation_age => node[:log_rotation_age],
      :log_rotation_size => node[:log_rotation_size],
      :checkpoint_timeout => node[:checkpoint_timeout],
      :checkpoint_segments => node[:checkpoint_segments],
      :wal_buffers => node[:wal_buffers],
      :wal_writer_delay => node[:wal_writer_delay],
      :postgres_root => postgres_root,
      :postgres_version => postgres_version,
      :hot_standby => "on"
    )
  end

  template "#{postgres_root}/#{postgres_version}/data/recovery.conf" do
    source "#{postgres_version}/recovery.conf.erb"
    owner "postgres"
    group "root"
    mode 0600
    backup 0
    variables(
      :standby_mode => "on",
      :primary_host => node.engineyard.environment.db_host,
      :primary_port => 5432,
      :primary_user => "postgres",
      :primary_password => node[:owner_pass],
      :trigger_file => "/tmp/postgresql.trigger"
    )
  end
end

file "#{postgres_root}/#{postgres_version}/custom.conf" do
  action :create
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  not_if { FileTest.exists?("#{postgres_root}/#{postgres_version}/custom.conf") }
end

template "#{postgres_root}/#{postgres_version}/data/pg_hba.conf" do
  owner 'postgres'
  group 'root'
  mode 0600
  source "#{postgres_version}/pg_hba.conf.erb"
  notifies :restart, resources(:service => "postgresql-#{postgres_version}")
  variables({
    :dbuser => node[:users].first[:username],
    :dbpass => node[:users].first[:password]
  })
end

service "postgresql-#{postgres_version}" do
  action [:enable, :start]
end

user "postgres" do
  action :unlock
end

username = node.engineyard.ssh_username
password = node.engineyard.ssh_password

execute "create-db-user#{username}" do
  command  %{psql -U postgres postgres -c \"CREATE USER #{username} with ENCRYPTED PASSWORD '#{password}' createdb\"}
  not_if %{psql -U postgres -c "select * from pg_roles" | grep #{username}}
end

if ['solo','db_master'].include?(node[:instance_role])
  execute "alter-db-user-postgres" do
    command %{psql -Upostgres postgres -c \"ALTER USER postgres with ENCRYPTED PASSWORD '#{password}'\"}
  end
end

node.engineyard.apps.each do |app|
  createdb app.database_name do
    owner username
  end
end
