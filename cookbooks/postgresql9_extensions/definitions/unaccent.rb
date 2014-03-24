define :postgresql9_unaccent do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    extname "unaccent"
    minimum_version 9.0
  end

end