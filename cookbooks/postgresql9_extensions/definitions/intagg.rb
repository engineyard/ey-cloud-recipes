define :postgresql9_intagg do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    extname "int_aggregate"
    supported_versions %w[9.0]
  end

end