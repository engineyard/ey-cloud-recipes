if ['solo', 'db_master', 'db_slave'].include?(node[:instance_role])
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
end
