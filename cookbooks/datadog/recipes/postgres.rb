if ['solo', 'db_master', 'db_slave'].include?(node[:instance_role])

  ey_cloud_report "datadog" do
   message "DataDog::Postgres Start"
  end

  execute "create-db-user#{node["postgres"]["dd-user"]}" do
    command  %{psql -U postgres postgres -c \"CREATE USER #{node["postgres"]["dd-user"]} with PASSWORD '#{node["postgres"]["dd-password"]}' \"}
    not_if %{psql -U postgres -c "select * from pg_roles" | grep #{node["postgres"]["dd-user"]}}
  end

  execute "grant-dd-user-stat" do
    command %{psql -U postgres postgres -c \"grant SELECT ON pg_stat_database to #{node["postgres"]["dd-user"]} \"}
    not_if %{psql -U postgres postgres -c "SELECT has_table_privilege('datadog', 'pg_stat_database', 'SELECT')" | grep "t"}
  end

  template '/home/deploy/datadog/.datadog-agent/agent/conf.d/postgres.yaml' do
    source 'postgres.yaml.erb'
    owner 'deploy'
    group 'deploy'
    mode 00764
    variables({
      :dd_pg_user => node["postgres"]["dd-user"],
      :dd_pg_pw => node["postgres"]["dd-password"]
      })
  end

end
