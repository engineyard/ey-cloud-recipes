define :postgresql9_pg_stat_statements do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "pg_stat_statements"
    minimum_version 9.2
  end

  #add shared_preload_libraries and pg_stat_statements to custom pgconf
  p = "/db/postgresql/#{@node[:postgres_version]}/custom.conf"
  ext_name = "pg_stat_statements"
  update_file "add #{ext_name} to #{p}" do
    action :append
    path p
    body <<-EOF
shared_preload_libraries = 'pg_stat_statements'

pg_stat_statements.max = 10000
pg_stat_statements.track = all
EOF
    not_if "grep '#{ext_name}' #{p}"
  end
end
