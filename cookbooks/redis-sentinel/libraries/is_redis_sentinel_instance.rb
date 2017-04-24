class Chef::Recipe
  # Return true if the we should install redis-sentinel on the current instance
  # Based on the settings in redis-sentinel/attributes/default.rb
  def is_redis_sentinel_instance(node_name, node_instance_role)
    case node['redis-sentinel']['install_type']
    when 'ALL_APP_INSTANCES'
      %w(solo app_master app).include?(node_instance_role)
    when 'ALL_APP_AND_UTIL_INSTANCES'
      %w(solo app_master app util).include?(node_instance_role)
    when 'ALL_APP_AND_NAMED_UTIL_INSTANCES'
      %w(solo app_master app).include?(node_instance_role) ||
        ((node_instance_role == 'util') &&
         (node_name == node['redis-sentinel']['utility_name']))
    when 'NAMED_UTILS'
      (node_instance_role == 'util') &&
        (node_name == node['redis-sentinel']['utility_name'])
    else
      false
    end
  end
end
