postgis_version = "1.5.2"
proj_version = "4.6.1"
geos_version = "3.2.2"

package_use "sci-libs/geos" do
  flags "-ruby"
end

enable_package "sci-libs/geos" do
  version geos_version
end
enable_package "sci-libs/proj" do
  version proj_version
end

enable_package "dev-db/postgis" do
  version postgis_version
end

package "dev-db/postgis" do
  version postgis_version
  action :install
end


