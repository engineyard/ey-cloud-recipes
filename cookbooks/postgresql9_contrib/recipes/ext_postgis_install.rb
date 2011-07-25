postgis_version = "1.5.2"

enable_package "dev-db/postgis" do
  version postgis_version
end

package "dev-db/postgis" do
  version postgis_version
  action :install
end

execute "activate_postgis" do
  command "eselect postgis"
  action :run
end
