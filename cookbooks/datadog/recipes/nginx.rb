
NGINX_CHECK = "sudo nginx -V 2>&1 | grep -o with-http_stub_status_module"

if `#{NGINX_CHECK}`.nil? || `#{NGINX_CHECK}`.empty?
  raise
end

template "#{node['nginx']['custom']}/custom.txt" do
  source "custom.txt.erb"
  owner "root"
  group "root"
  mode 00600
  variables({
    :internal_ip => node['ec2']['local_ipv4']
    })
end

# this might not be applicable for all instances
bash "cat into custom.conf" do
  user "root"
  cwd "#{node['nginx']['custom']}"
  code "cat custom.txt >> custom.conf "
  notifies :run, 'execute[nginx-reload]', :immediately
  not_if {File.readlines("#{node['nginx']['custom']}/custom.conf").grep(/nginx_status/).size > 0}
end

execute "nginx-reload" do
  command "nginx -s reload"
  action :nothing
end

file "#{node['nginx']['custom']}/custom.txt" do
  action :delete
end


template "/root/.datadog-agent/agent/conf.d/nginx.yaml" do
  source "nginx.yaml.erb"
  owner "root"
  group "root"
  mode 00744
  variables({
    :env_name => node[:environment][:name],
    :public_hostname => node["ec2"]["public_hostname"]
    })
end
