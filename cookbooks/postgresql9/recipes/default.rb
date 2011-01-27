if ['solo', 'db_master'].include?(node[:instance_role])
  require_recipe "postgresql9::client_config"
  require_recipe "postgresql9::server_install"
  require_recipe "postgresql9::gem"
  require_recipe "postgresql9::server_configure"
  require_recipe "postgresql9::eybackup"
end
if ['solo', 'app_master', 'app', 'util'].include?(node[:instance_role])
  require_recipe "postgresql9::client_config"
  require_recipe "postgresql9::database"
  require_recipe "postgresql9::server_install"
end
