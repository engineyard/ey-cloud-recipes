# ---- Modify pgsql config file ----
# config_options.each { |key, value|  key + ' = ' + value + "\n" }
Chef::Log.info "Config file to be modified #{config_options.inspect()}"

template "#{postgres_root}/#{postgres_version}/custom.conf" do
  source "custom.erb"
  owner "postgres"
  group "root"
  mode 0600
  backup 0
  # notifies :restart, resources(:service => "postgresql-#{postgres_version}")
  variables (config_options )
end


# ---- Execute sql ----
# Chef::Log.info "Execute sql" 
  
  
  