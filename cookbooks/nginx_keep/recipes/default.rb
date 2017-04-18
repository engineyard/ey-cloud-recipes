if ['app_master','app','solo'].include? node[:instance_role]

  template "/etc/nginx/servers/md2/custom.conf" do
    source "custom.conf.erb"
    owner "deploy"
    group "deploy"
    mode 00644
    variables({
      # :internal_ip => node['ec2']['local_ipv4'],
    })
    notifies :run, 'execute[nginx-reload]', :immediately
  end

  template "/etc/nginx/servers/md2/custom.ssl.conf" do
    source "custom.ssl.conf.erb"
    owner "deploy"
    group "deploy"
    mode 00644
    variables({
      # :internal_ip => node['ec2']['local_ipv4'],
    })
    notifies :run, 'execute[nginx-reload]', :immediately
  end

  execute "nginx-reload" do
    user "root"
    command "nginx -s reload"
    action :nothing
  end

end
