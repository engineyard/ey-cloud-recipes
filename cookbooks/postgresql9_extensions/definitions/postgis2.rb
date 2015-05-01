define :postgresql9_postgis2 do
  dbname_to_use = params[:name]

  if @node[:postgres_version] < 9.2 || (ey_release_version == '2009a' and @node[:postgres_version] == 9.2)
    Chef::Log.info("Postgis 2 is not supported with Postgres <=9.2 on 2009a/stable-v2.  Please, use the Postgis 1.5 extension instead (ext_postgis_install), move to a 12.11/stable-v4 environment, or upgrade to PostgreSQL 9.3.")
    exit(1)
  end

  if @node[:postgres_version] >= 9.2
    include_recipe "postgresql9_extensions::ext_postgis2_install"

    if ey_release_version == '2009a'
      postgis_version = "2.1.1"
    else
      postgis_version = "2.1.5"
    end

    if ['solo','db_master'].include?(@node[:instance_role])
      load_sql_file do
        db_name dbname_to_use
        minimum_version 9.2
        extname "postgis"
      end

      execute "Updating to correct postgis minor version" do
        # this is essentially a no-op if already on this version.
        command %Q{psql -U postgres -d #{dbname_to_use} -c 'ALTER EXTENSION postgis UPDATE TO "#{postgis_version}";'}
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
