define :postgresql9_postgis do
  include_recipe "postgresql9_contrib::ext_postgis_install"
  dbname_to_use = params[:name]
    
  load_sql_file do 
    db_name dbname_to_use
    filename "/usr/share/postgresql-9.0/contrib/postgis-1.5/postgis.sql" 
  end
  
  load_sql_file do 
    db_name dbname_to_use
    filename "/usr/share/postgresql-9.0/contrib/postgis-1.5/spatial_ref_sys.sql" 
  end
  
  load_sql_file do 
    db_name dbname_to_use
    filename"/usr/share/postgresql-9.0/contrib/postgis-1.5/postgis_comments.sql" 
  end
  
end
