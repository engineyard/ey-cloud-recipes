#
# Cookbook Name:: delayed_job
# Recipe:: default
#

WorkerRole = Struct.new(:count, :queue)

class GenericWorkerStrategy

  def self.generate(node)
    if node[:instance_role] == 'solo'
      Chef::Log.info "Delayed Job being configured for a solo instance"
      strategy = self.for_solo
    else
      strategy = self.for_cluster node[:instance_role], node[:ec2][:instance_type]
    end
    log strategy, node
    return strategy
  end

  def self.for_solo
    [ WorkerRole.new(1, nil) ]
  end

  def self.for_cluster(role, instance_type)
    case instance_type
      when 'm1.small'
        worker_count = 1
      when 'c1.medium'
        worker_count = 2
      when 'c1.xlarge'
        worker_count = 4
      else
        worker_count = 2
    end

    [ WorkerRole.new(worker_count, nil) ]
  end

  def self.log(strategy, node)
    strategy.each do | role |
      if role.queue.nil?
        Chef::Log.info "Delayed Job worker count has been set to '#{role.count}' as this is an EC2 instance of size #{node[:ec2][:instance_type]}"
      else
        Chef::Log.info "Delayed Job worker count has been set to '#{role.count}' for queue '#{role.queue}' as this is an EC2 instance of size #{node[:ec2][:instance_type]}"
      end
    end
  end

end


class ExamTimeWorkerStrategy

  def self.generate(node)
    if node[:instance_role] == 'solo'
      Chef::Log.info "Delayed Job being configured for a solo instance"
      strategy = self.for_solo
    else
      strategy = self.for_cluster node[:instance_role], node[:ec2][:instance_type], node
    end
    log strategy, node
    return strategy
  end

  def self.for_solo
    [
      WorkerRole.new(1, "mail"),
      WorkerRole.new(1, "scrape"),
      WorkerRole.new(1, "default")
    ]
  end

  def self.for_cluster(role, instance_type, node)
    worker_count_for_mail = 0
    worker_count_for_scrape = 0
    worker_count_for_default = 0
    utility_instances_present = ( node['utility_instances'].length > 0 )
    
    if role != 'util' # regular app instance
      case instance_type
        when 'm1.small'
          worker_count_for_default = 1
          worker_count_for_mail = 1
          worker_count_for_scrape = (utility_instances_present == true) ? 0 : 1
        when 'c1.medium'
          worker_count_for_default = 2
          worker_count_for_mail = 2
          worker_count_for_scrape = (utility_instances_present == true) ? 0 : 1
        when 'c1.xlarge'
          worker_count_for_default = 4
          worker_count_for_mail = 4
          worker_count_for_scrape = (utility_instances_present == true) ? 0 : 2
        else
          worker_count_for_default = 2
          worker_count_for_mail = 2
          worker_count_for_scrape = (utility_instances_present == true) ? 0 : 1
      end
    else # utility instance
      case instance_type
        when 'm1.small'
          worker_count_for_scrape = 1
        when 'm1.medium'
          worker_count_for_scrape =  2
        when 'm1.large'
          worker_count_for_scrape = 4
        when 'm1.xlarge'
          worker_count_for_scrape =  6
        else
          worker_count_for_scrape = 2
      end
    end


    [
      WorkerRole.new(worker_count_for_mail, 'mail'),
      WorkerRole.new(worker_count_for_default, 'default'),
      WorkerRole.new(worker_count_for_scrape, 'scrape')
    ]
  end

  def self.log(strategy, node)
    strategy.each do | role |
      if role.queue.nil?
        Chef::Log.info "Using ExamTime Worker Strategy: Delayed Job worker count has been set to '#{role.count}' as this is an EC2 instance of size #{node[:ec2][:instance_type]}"
      else
        Chef::Log.info "Using ExamTime Worker Strategy: Delayed Job worker count has been set to '#{role.count}' for queue '#{role.queue}' as this is an EC2 instance of size #{node[:ec2][:instance_type]}"
      end
    end
  end

end

class NamedWorkerStrategy < GenericWorkerStrategy

  def self.for_solo
    [
      WorkerRole.new(1, 'reporting'),
      WorkerRole.new(1, 'util'),
      WorkerRole.new(1, 'mail')
    ]
  end

  def self.for_cluster(role, instance_type)
    reporting_count = 0
    util_count = 0
    mail_count = 0
    
    case instance_type
      when 'm1.small'
        reporting_count = 1 if role == 'app_master'
        util_count = 1 if role == 'app'
        mail_count = 1
      when 'c1.medium'
        reporting_count = 1 if role == 'app_master'
        util_count = 1 if role == 'app'
        mail_count = 2
      when 'c1.xlarge'
        reporting_count = 1 if role == 'app_master'
        util_count = 2 if role == 'app'
        mail_count = 4
      else
        reporting_count = 1 if role == 'app_master'
        util_count = 1 if role == 'app'
        mail_count = 2
    end
    
    [
      WorkerRole.new(reporting_count, 'reporting'),
      WorkerRole.new(util_count, 'util'),
      WorkerRole.new(mail_count, 'mail')
    ]
  end

end

if ( %w(solo app_master app).include?(node[:instance_role]) || (node[:instance_role] == 'util' && node[:name] !~ /^(mongodb|redis|memcache)/) )

  node[:applications].each do |app_name,data|

    template "/etc/monit.d/#{app_name}_delayed_jobs.monitrc" do
      source "dj.monitrc.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        :worker_roles => ExamTimeWorkerStrategy.generate(node),
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
