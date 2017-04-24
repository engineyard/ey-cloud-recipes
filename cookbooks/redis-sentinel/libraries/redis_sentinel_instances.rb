class Chef::Recipe
  # Returns the list of redis-sentinel instances
  # Based on the settings in redis-sentinel/attributes/default.rb
  def redis_sentinel_instances
    all_app_instances = node['engineyard']['environment']['instances'].map do |i|
      i['private_hostname'] if ['app_master', 'app', 'solo'].include?(i['role'])
    end.compact

    all_util_instances = node['engineyard']['environment']['instances'].map do |i|
      i['private_hostname'] if i['role'] == 'util'
    end.compact

    named_utility_instances = node['utility_instances'].map do |i|
      i['hostname'] if i['name'] == node['redis-sentinel']['utility_name']
    end.compact

    case node['redis-sentinel']['install_type']
    when 'ALL_APP_INSTANCES'
      all_app_instances
    when 'ALL_APP_AND_UTIL_INSTANCES'
      all_app_instances + all_util_instances
    when 'ALL_APP_AND_NAMED_UTIL_INSTANCES'
      all_app_instances + named_utility_instances
    when 'NAMED_UTILS'
      named_utility_instances
    else
      # We should never get to this case
      # If we do, we return an empty array
      # to help in debugging why node['redis-sentinel']['install_type'] wasn't properly set
      []
    end
  end
end
