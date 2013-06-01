# are the backups encrypted
component_keys = node[:engineyard][:environment][:apps].map do |app| 
  app[:components].map do |component| 
    component[:key]
  end
end

default[:encrypted_backups] = component_keys.flatten.include?('encrypted_backup')