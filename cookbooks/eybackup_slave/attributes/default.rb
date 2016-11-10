# are the backups encrypted
components = node[:engineyard][:environment][:apps].map {|a| a[:components]}.flatten
default[:encrypted_backups] = components.map {|c| c[:key]}.include?('encrypted_backup')
if default[:encrypted_backups]
  default[:public_key] = components.find {|c| c[:public_key]}[:public_key]
end
