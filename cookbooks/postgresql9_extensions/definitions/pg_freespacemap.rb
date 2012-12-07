define :postgresql9_pg_freespacemap do
 dbname_to_use = params[:name]

  load_sql_file do 
    db_name dbname_to_use
    extname "pg_freespacemap"
    supported_versions %w[9.0 9.2]
  end
end
