if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/secrets.yml"do
      source 'secrets.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
    end
  end
end
