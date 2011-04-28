# This recipe installs a custom.cnf that will make mysql take less space on the instance to ensure of no resource issues.

service "mysql" do
  case node[:platform]
    when "gentoo"
      service_name "mysql"
    else
      service_name "mysql"
    end
  supports :restart => true, :reload => true, :status => true
  action :nothing
end

template "/etc/mysql.d/custom.cnf" do
  owner "root"
  group "root"
  source "custom.cnf.erb"
  mode 0655
  backup 0
  variables({
  :buffer_pool_size => "32M",
  :additional_buffer_pool_size => "16M"
  })
  notifies :restart, resources(:service => "mysql"), :delayed
end
