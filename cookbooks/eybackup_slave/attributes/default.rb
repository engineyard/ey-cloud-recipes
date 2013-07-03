# are the backups encrypted
components = node[:engineyard][:environment][:apps].map {|a| a[:components]}.flatten
default[:encrypted_backups] = components.map {|c| c[:key]}.include?('encrypted_backup')
default[:public_key] = default[:encrypted_backups] ? components.find {|c| c[:public_key]}[:public_key] : nil