define :postgresql9_pg_stat_statements do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "pg_stat_statements"
    supported_versions %w[9.2]
  end
end
