default[:db_restore] = {
  :app_name => "",  # The application name as it appears in the Engine Yard dashboard
  :db_type => "",   # mysql or postgresql
  :source_environment_name => "", # The name of the environment containing the backup that you want to restore
  :backup_bucket => "" # See the README.md for information on obtaining this value
}
