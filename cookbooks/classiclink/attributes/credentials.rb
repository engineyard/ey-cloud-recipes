if environment_metadata = node[:engineyard][:environment][:components].find{|c| c['key'] == 'environment_metadata'}
  default[:classiclink_iam_id]  = environment_metadata['classiclink_iam_id']
  default[:classiclink_iam_key] = environment_metadata['classiclink_iam_key']
end
