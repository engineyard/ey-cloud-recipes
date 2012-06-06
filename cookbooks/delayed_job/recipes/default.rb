#
# Cookbook Name:: delayed_job
# Recipe:: default
#

if node[:instance_role] == "solo" || (node[:instance_role] == "app" && node[:name] !~ /^(mongodb|redis|memcache)/)

  node[:applications].each do |app_name,data|

    if node[:instance_role] == 'solo'
      Chef::Log.info "Delayed Job being configured for a solo instance"
      worker_count = 1
    else
      case node[:ec2][:instance_type]
        when 'm1.small'
          Chef::Log.info "Delayed Job being configured for an EC2 m1.small"
          worker_count = 2
        when 'c1.medium'
          Chef::Log.info "Delayed Job being configured for an EC2 c1.medium"
          worker_count = 4
        when 'c1.xlarge'
          Chef::Log.info "Delayed Job being configured for an EC2 c1.xlarge"
          worker_count = 8
        else 
          Chef::Log.info "Delayed Job being configured for an EC2 instance of unknown size" 
          worker_count = 2
      end
    end
    Chef::Log.info "Delayed Job worker count has been set to '#{worker_count}'"

    template "/etc/monit.d/#{app_name}_delayed_jobs.monitrc" do
      source "dj.monitrc.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        :num_workers => worker_count,
        :app_name => app_name,
        :user => node[:owner_name],
        :worker_name => "delayed_job",
        :framework_env => node[:environment][:framework_env]
      })
    end

    execute "monit reload" do
       action :run
       epic_fail true
    end

  end

end
