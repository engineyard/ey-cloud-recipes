require 'pp'
#
# Cookbook Name:: postgres
# Recipe:: default
#
postgres_root    = '/var/lib/postgresql'
postgres_version = '8.3'

directory '/db/postgresql' do
  owner 'postgres'
  group 'postgres'
  mode  '0755'
  action :create
  recursive true
end

link "setup-postgresq-db-my-symlink" do
  to '/db/postgresql'
  target_file postgres_root
end

execute "setup-postgresql-db-symlink" do
  command "rm -rf /var/lib/postgresql; ln -s /data/postgresql /var/lib/postgresql"
  action :run
  only_if "if [ ! -L #{postgres_root} ]; then exit 0; fi; exit 1;"
end

execute "init-postgres" do
  command "initdb -D #{postgres_root}/#{postgres_version}/data"
  action :run
  user 'postgres'
  only_if "if [ ! -d #{postgres_root}/#{postgres_version}/data ]; then exit 0; fi; exit 1;"
end

execute "enable-postgres" do
  command "rc-update add postgresql-#{postgres_version} default"
  action :run
end

execute "restart-postgres" do
  command "/etc/init.d/postgresql-#{postgres_version} restart"
  action :run
  not_if "/etc/init.d/postgresql-8.3 status | grep -q start"
end

node[:applications].each do |app_name,data|
  user = node[:users].first
  db_name = "#{app_name}_#{node[:environment][:framework_env]}"

  execute "create-db-user-#{user[:username]}" do
    command "`psql -c '\\du' | grep -q '#{user[:username]}'`; if [ $? -eq 1 ]; then\n  psql -c \"create user #{user[:username]} with encrypted password \'#{user[:password]}\'\"\nfi"
    action :run
    user 'postgres'
  end

  execute "create-db-#{db_name}" do
    command "`psql -c '\\l' | grep -q '#{db_name}'`; if [ $? -eq 1 ]; then\n  createdb #{db_name}\nfi"
    action :run
    user 'postgres'
  end

  execute "grant-perms-on-#{db_name}-to-#{user[:username]}" do
    command "/usr/bin/psql -c 'grant all on database #{db_name} to #{user[:username]}'"
    action :run
    user 'postgres'
  end

  execute "alter-public-schema-owner-on-#{db_name}-to-#{user[:username]}" do
    command "/usr/bin/psql #{db_name} -c 'ALTER SCHEMA public OWNER TO #{user[:username]}'"
    action :run
    user 'postgres'
  end

  template "/data/#{app_name}/shared/config/keep.database.yml" do
    source "database.yml.erb"
    owner user[:username]
    group user[:username]
    mode 0744
    variables({
        :username => user[:username],
        :app_name => app_name,
        :db_pass => user[:password]
    })
  end

  template "/data/#{app_name}/shared/config/database.yml" do
    source "database.yml.erb"
    owner user[:username]
    group user[:username]
    mode 0744
    variables({
        :username => user[:username],
        :app_name => app_name,
        :db_pass => user[:password]
    })
  end
end
