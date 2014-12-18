if ['solo','db_master'].include?(node[:instance_role])
  datadir = "#{node[:postgres_root]}#{node[:postgres_version]}/data/"
  dataroot = "/db/postgresql/"
  reps = node[:engineyard][:environment][:instances].map{|i| i['private_hostname'] if i['role'][/db_slave/]}.compact
  dbs = node[:engineyard][:environment][:instances].map{|i| i['private_hostname'] if i['role'][/^app|solo|util/]}.compact
  
  replicas = ''
  non_dbs = ''
  
  reps.each do |r|
    replicas << r << ' '
  end
  
  dbs.each do |n|
    non_dbs << n << ' '
  end
  
  replicas.rstrip!
  non_dbs.rstrip!
  
  template "/engineyard/bin/generate_server_ssl_certs.sh" do
    source "generate_server_ssl_certs.sh.erb"
    owner "root"
    group "root"
    mode 0755
    variables({
      :replicas => replicas,
      :datadir => datadir,
      :dataroot => dataroot,
    })
  end
  
  execute "Generate DB Server SSL Certs" do
    command "/engineyard/bin/generate_server_ssl_certs.sh"
    action :run
    not_if { File.exists?("#{datadir}/root.crt") }
  end
  
  template "/engineyard/bin/generate_user_ssl_certs.sh" do
    source "generate_user_ssl_certs.sh.erb"
    owner "root"
    group "root"
    mode 0755
    variables({
      :key_users => 'deploy postgres',
      :replicas => replicas,
      :datadir => datadir,
      :dataroot => dataroot,
    })
  end
  
  execute "Generate DB User SSL Certs" do
    command "/engineyard/bin/generate_user_ssl_certs.sh"
    action :run
    not_if { File.exists?("#{dataroot}/pgkeygen/deploy/postgresql.key") && File.exists?("#{dataroot}/pgkeygen/postgres/postgresql.key") }
  end
  
  
  template "/engineyard/bin/copy_server_ssl_certs.sh" do
    source "copy_server_ssl_certs.sh.erb"
    owner "root"
    group "root"
    mode 0755
    variables({
      :replicas => replicas,
      :datadir => datadir,
      :dataroot => dataroot,
    })
  end
  
  execute "Copy DB Server SSL Certs" do
    command "/engineyard/bin/copy_server_ssl_certs.sh"
    action :run
    only_if { File.exists?("#{datadir}/root.crt") }
  end
  
  template "/engineyard/bin/copy_user_ssl_certs.sh" do
    source "copy_user_ssl_certs.sh.erb"
    owner "root"
    group "root"
    mode 0755
    variables({
      :replicas => replicas,
      :instances => non_dbs,
      :datadir => datadir,
      :dataroot => dataroot,
    })
  end
  
  execute "Copy DB User SSL Certs" do
    command "/engineyard/bin/copy_user_ssl_certs.sh"
    action :run
    only_if { File.exists?("#{dataroot}/pgkeygen/deploy/postgresql.key") && File.exists?("#{dataroot}/pgkeygen/postgres/postgresql.key") }
  end
end