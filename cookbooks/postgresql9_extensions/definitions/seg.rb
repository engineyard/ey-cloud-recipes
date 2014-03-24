define :postgresql9_seg do
 dbname_to_use = params[:name]

  load_sql_file do
    db_name dbname_to_use
    extname "seg"
    minimum_version 9.0
  end
end
