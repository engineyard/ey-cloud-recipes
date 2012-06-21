#
# Cookbook Name:: delayed_job
# Recipe:: default
#

if ( %w(solo app_master app).include?(node[:instance_role]) || (node[:instance_role] == 'util' && node[:name] !~ /^(mongodb|redis|memcache)/) )

  node[:applications].each do |app_name,data|

    if node[:instance_role] == 'solo'
      Chef::Log.info "Delayed Job being configured for a solo instance"
      worker_count = 1
    else
      case node[:ec2][:instance_type]
        when 'm1.small'
          worker_count = 1
        when 'c1.medium'
          worker_count = 2
        when 'c1.xlarge'
          worker_count = 4
        else
          worker_count = 2
      end
    end
    Chef::Log.info "Delayed Job worker count has been set to '#{worker_count}' as this is an EC2 instance of size #{node[:ec2][:instance_type]}"

    template "/etc/monit.d/#{app_name}_delayed_jobs.monitrc" do
      source "dj.monitrc.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        :num_workers => worker_count,
        :app_name => app_name,
        :app_dir => "/data/#{app_name}/current",
        :pid_dir => "/data/#{app_name}/current/tmp/pids",
        :user => node[:owner_name],
        :timeout => 240, # seconds
        :worker_name => 'delayed_job',
        :framework_env => node[:environment][:framework_env]
      })
    end

    execute "monit reload" do
       action :run
       epic_fail true
    end

  end

end
