# determine the number of workers to run based on instance size
worker_count = if node[:instance_role] == 'solo'
                 1
               else
                 case node[:ec2][:instance_type]
                 when 't2.micro' then 1
                 when 't2.small' then 1
                 when 't2.xlarge' then 4
                 when 't2.2xlarge' then 8
                 when 'm3.large' then 4
                 when 'm3.xlarge' then 8
                 when 'm3.2xlarge' then 8
                 when 'c3.large' then 4
                 when 'c3.xlarge' then 8
                 when 'c3.2xlarge' then 8
                 when 'c3.4xlarge' then 16
                 when 'c3.8xlarge' then 32
                 when 'm4.large' then 4
                 when 'm4.xlarge' then 8
                 when 'm4.2xlarge' then 8
                 when 'm4.4xlarge' then 16
                 when 'm4.10xlarge' then 40
                 when 'm4.16xlarge' then 64
                 when 'c4.large' then 4
                 when 'c4.xlarge' then 8
                 when 'c4.2xlarge' then 8
                 when 'c4.4xlarge' then 16
                 when 'c4.8xlarge' then 32
                 when 'r3.large' then 4
                 when 'r3.xlarge' then 8
                 when 'r3.2xlarge' then 16
                 when 'r3.4xlarge' then 32
                 when 'r3.8xlarge' then 64
                 when 'r4.large' then 4
                 when 'r4.xlarge' then 8
                 when 'r4.2xlarge' then 16
                 when 'r4.4xlarge' then 32
                 when 'r4.8xlarge' then 64
                 when 'r4.16xlarge' then 128
                 else # default
                   2
                 end
               end

default['delayed_job4']['is_dj_instance'] = node[:instance_role] == "solo" || (node[:instance_role] == "util" && node[:name] !~ /^(mongodb|redis|memcache)/)
default['delayed_job4']['worker_count'] = worker_count
default['delayed_job4']['worker_memory'] = 300
