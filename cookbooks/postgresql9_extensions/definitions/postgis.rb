define :postgresql9_postgis do
  include_recipe "postgresql9_extensions::ext_postgis_install"
  dbname_to_use = params[:name]
    
  load_sql_file do 
    db_name dbname_to_use
    supported_versions %w[9.0]
    extname "postgis-1.5/postgis" 
  end
  
  load_sql_file do 
    db_name dbname_to_use
    supported_versions %w[9.0]
    extname "postgis-1.5/spatial_ref_sys" 
  end
  
  load_sql_file do 
    db_name dbname_to_use
    supported_versions %w[9.0]
    extname"postgis-1.5/postgis_comments" 
  end
  
end
