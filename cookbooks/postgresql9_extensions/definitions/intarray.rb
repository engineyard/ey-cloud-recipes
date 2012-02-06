define :postgresql9_intarray do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    extname "intarray"
    supported_versions %w[9.0 9.1]
  end

end