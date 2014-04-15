define :postgresql9_uuid_ossp do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "uuid-ossp"
    minimum_version 9.0
  end
end
