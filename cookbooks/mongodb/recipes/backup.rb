if @node[:mongo_backup]
  gem_package "aws-s3"
  partition    = "data"
  service_name = "mongo"
  dbpath = "/#{partition}/mongodb/#{service_name}/"
  
  template "/etc/.mongodb.backups.yml" do
    owner "root"
    group "root"
    mode 0600
    source "mongodb.backups.yml.erb"
    variables(:config => {
      :keep           => node[:backup_window] || 14,
      :aws_secret_id  => node[:aws_secret_id],
      :aws_secret_key => node[:aws_secret_key],
      :env            => node[:environment][:name],
      :databases      => {},
      :dbuser         => nil, # not implemented
      :dbpass         => nil, # not implemented
    })
  end
  
  remote_file "/usr/local/bin/mongodb_file_backup" do
    source "mongodb_file_backup"
    owner "root"
    group "root"
    mode 0755
  end
  
  cron_hour = if node[:backup_interval].to_s == '24' || !node[:backup_interval]
    "1" # 0100 Pacific, per support's request
    # NB: Instances run in the Pacific (Los Angeles) timezone
  elsif node[:backup_interval]
    "*/#{node[:backup_interval]}"
  end
  
  cron "mongodb_backup" do
    minute   '10'
    hour     cron_hour
    day      '*'
    month    '*'
    weekday  '*'
    command  "/usr/local/bin/mongodb_file_backup #{dbpath}"
    not_if { node[:backup_window].to_s == '0' }
  end
  
  
  
end