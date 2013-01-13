define :postgresql9_postgis2 do
  dbname_to_use = params[:name]

  if @node[:postgres_version] == "9.2"
    include_recipe "postgresql9_extensions::ext_postgis2_install"

    execute "Create PostGIS Extension" do
      command "psql -U postgres -d #{dbname_to_use} -c \"CREATE EXTENSION postgis;\""
    end

    execute "Grant permissions to the deploy user on the geometry_columns schema" do
      command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on geometry_columns to deploy\""
    end

    execute "Grant permissions to the deploy user on the spatial_ref_sys schema" do
      command "psql -U postgres -d #{dbname_to_use} -c \"GRANT all on spatial_ref_sys to deploy\""
    end

  end
end
