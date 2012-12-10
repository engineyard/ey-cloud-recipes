define :postgresql9_postgis do
  dbname_to_use = params[:name]

  if @node[:postgres_version] == "9.0"
    include_recipe "postgresql9_extensions::ext_postgis_install"

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
  elsif @node[:postgres_version] == "9.1"
    include_recipe "postgresql9_extensions::ext_postgis_install"

     execute "Postgresql loading postgis on database #{dbname_to_use} for version 9.1 as a contrib" do
       command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.1/contrib/postgis-1.5/postgis.sql"
     end

    execute "Postgresql loading spatial_ref_sys on database #{dbname_to_use} for version 9.1 as a contrib" do
      command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.1/contrib/postgis-1.5/spatial_ref_sys.sql"
    end

    execute "Postgresql loading postgis_comments on database #{dbname_to_use} for version 9.1 as a contrib" do
      command "psql -U postgres -d #{dbname_to_use} -f /usr/share/postgresql-9.1/contrib/postgis-1.5/postgis_comments.sql"
    end
  elsif @node[:postgres_version] == "9.2"
    Chef::Log.info "PostGIS support for 9.2 is coming soon"
  end

  execute "Grant permissions to the deploy user on the geometry_columns schema" do
    command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on geometry_columns to deploy\""
  end

  execute "Grant permissions to the deploy user on the spatial_ref_sys schema" do
    command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on spatial_ref_sys to deploy\""
  end
end
