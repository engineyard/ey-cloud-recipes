define :postgresql9_file_fdw do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "file_fdw"
    minimum_version 9.1
  end
end
