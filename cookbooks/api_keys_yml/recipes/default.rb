if ['app_master', 'app'].include?(node[:instance_role])

  template "/data/#{app}/shared/config/api-keys.yml"do
    source 'api-keys.yml.erb'
    owner node[:owner_name]
    group node[:owner_name]
    mode 0655
    backup 0
    # Pass a hash of variables to the method below and they will be available as local variables in the template.
    # For API keys this is usually completely unnecessary
    # variables()
  end

end