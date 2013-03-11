define :postgresql9_postgis2 do
  dbname_to_use = params[:name]

  if @node[:postgres_version] == "9.2"
    include_recipe "postgresql9_extensions::ext_postgis2_install"

    load_sql_file do
      db_name dbname_to_use
      supported_versions %w[9.2]
      extname "postgis"
    end

    execute "Grant permissions to the deploy user on the geometry_columns schema" do
      command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on geometry_columns to deploy\""
    end

    execute "Grant permissions to the deploy user on the spatial_ref_sys schema" do
      command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on spatial_ref_sys to deploy\""
    end

  end
end
