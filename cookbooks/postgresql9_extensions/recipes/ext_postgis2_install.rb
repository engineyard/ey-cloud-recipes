if @node[:postgres_version] >= 9.2
  postgis_version = "2.1.1"
  proj_version = "4.6.1"
  geos_version = "3.4.2"
  gdal_version = "1.10.0-r1"

  package_use "sci-libs/geos" do
    flags "-ruby"
  end

  enable_package "sci-libs/gdal" do
    version gdal_version
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
end
