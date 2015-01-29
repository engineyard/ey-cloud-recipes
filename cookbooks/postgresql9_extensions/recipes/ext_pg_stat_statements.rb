directory = "#{@node[:postgres_root]}#{@node[:postgres_version]}"

execute "append to custom.conf" do
  command %Q{echo "include \'#{directory}/custom_pg_stat_statements.conf\'" >> #{directory}/custom.conf}
  not_if { File.exists?("#{directory}/custom_pg_stat_statements.conf") }
end

template "#{@node[:postgres_root]}#{@node[:postgres_version]}/custom_pg_stat_statements.conf" do
  source "custom_pg_stat_statements.erb"
  owner "postgres"
  group "root"
  mode 0600
  backup 0
  variables({
    :db_version => @node[:postgres_version],
    :shared_preload_libraries => "'pg_stat_statements'"
  })
end

execute "restarting postgres service" do
  command "/etc/init.d/postgresql-#{@node[:postgres_version]} reload"
end
