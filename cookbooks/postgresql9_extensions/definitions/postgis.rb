define :postgresql9_postgis do
  dbname_to_use = params[:name]
  
  if ey_release_version == '1211' or @node[:postgres_version] >= 9.3
    Chef::Log.info "Postgis 1.5 is not supported on versions 9.3 and higher nor on 12.11/stable-v4 at all; your current version is #{@node[:postgres_version]}/#{ey_release_version}. Please use the postgis2 extension instead."
    exit(1)
  else
    include_recipe "postgresql9_extensions::ext_postgis_install"
    
    if ['solo','db_master'].include?(@node[:instance_role])
      if @node[:postgres_version] == 9.0
        
          load_sql_file do
            db_name dbname_to_use
            minimum_version 9.0
            extname "postgis-1.5/postgis"
          end
      
          load_sql_file do
            db_name dbname_to_use
            minimum_version 9.0
            extname "postgis-1.5/spatial_ref_sys"
          end
      
          load_sql_file do
            db_name dbname_to_use
            minimum_version 9.0
            extname"postgis-1.5/postgis_comments"
          end
      elsif @node[:postgres_version] >= 9.1
        pgversion = @node[:postgres_version]
      
         execute "Postgresql loading postgis 1.5 on database #{dbname_to_use} for version #{pgversion}" do
           command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-#{pgversion}/contrib/postgis-1.5/postgis.sql"
         end
      
        execute "Postgresql loading spatial_ref_sys on database #{dbname_to_use} for version #{pgversion}" do
          command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-#{pgversion}/contrib/postgis-1.5/spatial_ref_sys.sql"
        end
      
        execute "Postgresql loading postgis_comments on database #{dbname_to_use} for version #{pgversion}" do
          command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-#{pgversion}/contrib/postgis-1.5/postgis_comments.sql"
        end
      end
      
      execute "Grant permissions to the deploy user on the geometry_columns schema" do
        command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on geometry_columns to deploy\""
      end
      
      execute "Grant permissions to the deploy user on the spatial_ref_sys schema" do
        command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on spatial_ref_sys to deploy\""
      end
    end
  end
end
