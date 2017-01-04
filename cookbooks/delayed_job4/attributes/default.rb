# determine the number of workers to run based on instance size
if node[:instance_role] == 'solo'
  worker_count = 1
else
  case node[:ec2][:instance_type]
  when 'm1.small' then worker_count = 2
  when 'c1.medium' then worker_count = 4
  when 'c1.xlarge' then worker_count = 8
  else
    worker_count = 2
  end
end

default['delayed_job4']['is_dj_instance'] = node[:instance_role] == "solo" || (node[:instance_role] == "util" && node[:name] !~ /^(mongodb|redis|memcache)/)
default['delayed_job4']['worker_count'] = worker_count
default['delayed_job4']['worker_memory'] = 300
