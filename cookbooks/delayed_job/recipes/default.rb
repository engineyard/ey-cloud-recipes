#
# Cookbook Name:: delayed_job
# Recipe:: default
#

if node[:instance_role] == "solo" || (node[:instance_role] == "util" && node[:name] !~ /^(mongodb|redis|memcache)/)
  node[:applications].each do |app_name,data|
  
    # determine the number of workers to run based on instance size
    if node[:instance_role] == 'solo'
      worker_count = 1
    else
      case node[:ec2][:instance_type]
      when 'm1.small': worker_count = 2
      when 'c1.medium': worker_count = 4
      when 'c1.xlarge': worker_count = 8
      else 
        worker_count = 2
      end
    end
    
    worker_count.times do |count|
      template "/etc/monit.d/delayed_job#{count+1}.#{app_name}.monitrc" do
        source "dj.monitrc.erb"
        owner "root"
        group "root"
        mode 0644
        variables({
          :app_name => app_name,
          :user => node[:owner_name],
          :worker_name => "delayed_job#{count+1}",
          :framework_env => node[:environment][:framework_env]
        })
      end
    end
    
    execute "monit-reload-restart" do
       command "sleep 30 && monit reload"
       action :run
    end
      
  end
end