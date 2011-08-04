define :postgresql9_postgis do
  # dbname_to_use = params[:name]
  # execute "create postgistemplate and drop db" do
  #   
  #   command "psql -U postgres -d #{dbname_to_use} -c "createdb postgistemplate";"
  #   command "psql -U postgres -d #{dbname_to_use} -c "createlang plpgsql postgistemplate";"
  #   
  # end
  
  include_recipe "postgresql9_contrib::ext_postgis_install"

end
