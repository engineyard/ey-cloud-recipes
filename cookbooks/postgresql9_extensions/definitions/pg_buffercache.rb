define :postgresql9_pg_buffercache do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    extname "pg_buffercache"
    supported_versions %w[9.0]
  end
end