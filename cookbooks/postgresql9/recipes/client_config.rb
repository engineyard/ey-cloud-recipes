template "/root/.pgpass" do
  backup 0
  mode 0600
  owner 'root'
  group 'root'
  source 'pgpass.erb'
  variables({
    :dbpass => node.engineyard.environment.ssh_password
  })
end

execute "touch ~/.bash_login" do
  action :run
end

update_file "add_PGUSER_to_root_bash_login" do
  path "/root/.bash_login"
  body "export PGUSER='postgres'"
  not_if "grep 'PGUSER' /root/.bash_login"
end
