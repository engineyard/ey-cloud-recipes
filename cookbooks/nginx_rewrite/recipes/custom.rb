template "/data/nginx/servers/#{node['app_name']}/custom.conf" do
	source 'custom.conf.erb'
	owner  node['owner_name']
	group  node['owner_name']
	mode	 0644
	only_if ['app_master', 'app', 'solo'].include? node['instance_role']
end
