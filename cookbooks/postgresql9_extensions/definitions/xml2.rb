define :postgresql9_xml2 do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    extname "xml2"
    supported_versions %w[9.1]
  end

end