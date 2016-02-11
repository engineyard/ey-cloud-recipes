


if db_master?
  node[:applications].each do |app_name, data|
    template "/home/#{node[:owner_name]}/download.yml" do
      source 'download.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
      variables({
          :app_name => app_name
      })
    end

    template "/home/#{node[:owner_name]}/download_backup.sh" do
      source 'download_backup.sh.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0777
      backup 0
      variables({
          :app_name => app_name
      })
    end
  end
end
