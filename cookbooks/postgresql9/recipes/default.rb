if ['solo', 'db_master','db_slave'].include?(node[:instance_role])
  require_recipe "postgresql9::client_config"
  require_recipe "postgresql9::server_install"
  require_recipe "postgresql9::gem"
  require_recipe "postgresql9::server_configure"
  require_recipe "postgresql9::eybackup"
  require_recipe "postgresql9::mysql_slimdown"
end
if ['solo', 'app_master', 'app', 'util'].include?(node[:instance_role])
  require_recipe "postgresql9::client_config"
  require_recipe "postgresql9::database"
  require_recipe "postgresql9::server_install"
  require_recipe "postgresql9::enable_9"
end
