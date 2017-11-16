if ['app_master', 'app', 'solo'].include?(node[:instance_role])

  #Install config files for blocking bots and referrals
  remote_file "/data/nginx/servers/blacklist.conf" do
    source "blacklist.conf"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
  end

  #Install config files for blocking ips
  remote_file "/data/nginx/servers/blockips.conf" do
    source "blacklist.conf"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
  end

  # Set temp file with config to be added
  remote_file "/tmp/nginx_blocking_append.conf" do
    user "deploy"
    source "nginx_blocking_append.txt"
  end
  
  node[:applications].each do |app, data|
    
    Execute "Clean up Nginx blocking config from earlier runs" do
      user "deploy"
      command "sed '/#---BOT-IP_BLOCKING-START/,/#---BOT-IP_BLOCKING-END/d' > /data/nginx/servers/#{app}/custom.conf"
    end

    Execute "Config Nginx to block bots/ips" do
      user "deploy"
      command "cat /tmp/nginx_blocking_append.conf >> /data/nginx/servers/#{app}/custom.conf"
    end

    Execute "Config Nginx to block bots/ips" do
      user "deploy"
      command "cat /tmp/nginx_blocking_append.conf >> /data/nginx/servers/#{app}/custom.ssl.conf"
    end

  end

  Execute "Remove nginx_blocking_append temp file" do
    command "rm /tmp/nginx_blocking_append.conf"
  end
  
  Execute "Reload nginx config" do
    command "sudo /etc/init.d/nginx reload"
  end

end
