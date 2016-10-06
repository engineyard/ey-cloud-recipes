if environment_metadata = node[:engineyard][:environment][:components].find{|c| c['key'] == 'environment_metadata'}
  default[:classiclink_vpc_id]            = environment_metadata['classiclink_vpc_id']
  default[:classiclink_security_group_id] = environment_metadata['classiclink_security_group_id']
end
