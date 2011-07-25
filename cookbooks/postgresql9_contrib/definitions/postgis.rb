define :postgresql9_postgis, :dbname => nil do
  include_recipe "postgresql9_contrib::ext_postgis_install"

end
