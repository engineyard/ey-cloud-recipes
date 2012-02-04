define :postgresql9_postgis do
  include_recipe "postgresql9_extensions::ext_postgis_install"
  dbname_to_use = params[:name]
    
  if @node[:postgres_version] == "9.0"
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
  #elsif @node[:postgres_version] == "9.1" 
    
    #  execute "Postgresql loading postgis on database #{db_name} for version 9.1 as a contrib" do
    #    command "psql -U postgres -d #{db_name} -f /usr/share/postgresql-9.1/contrib/postgis-1.5/postgis.sql"
    #  end
    #  
    # execute "Postgresql loading spatial_ref_sys on database #{db_name} for version 9.1 as a contrib" do
    #   command "psql -U postgres -d #{db_name} -f /usr/share/postgresql-9.1/contrib/postgis-1.5/spatial_ref_sys.sql"
    # end
    # 
    # execute "Postgresql loading postgis_comments on database #{db_name} for version 9.1 as a contrib" do
    #   command "psql -U postgres -d #{db_name} -f /usr/share/postgresql-9.1/contrib/postgis-1.5/postgis_comments.sql"
    # end
     
  end
end
