define :postgresql9_postgis do
  include_recipe "postgresql9_contrib::ext_postgis_install"
  dbname_to_use = params[:name]
  
  execute "create postgistemplate and drop db" do
    
   # command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.0/contrib/postgis-1.5/postgis.sql"
   # command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.0/contrib/postgis-1.5/spatial_ref_sys.sql"
   # command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.0/contrib/postgis-1.5/postgis_comments.sql"
   
   load_sql_file dbname_to_use, "/usr/share/postgresql-9.0/contrib/postgis-1.5/postgis.sql" 
   load_sql_file dbname_to_use, "/usr/share/postgresql-9.0/contrib/postgis-1.5/spatial_ref_sys.sql"
   load_sql_file dbname_to_use, "/usr/share/postgresql-9.0/contrib/postgis-1.5/postgis_comments.sql"
    
  end

end
