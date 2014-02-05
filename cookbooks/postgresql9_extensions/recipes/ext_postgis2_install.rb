if @node[:postgres_version] == "9.2"
  postgis_version = "2.0.2"
  proj_version = "4.6.1"
  geos_version = "3.2.2"

  if release_version == "v2"
    gdal_version = "1.8.1-r1"
  else
    gdal_version = "1.8.1-r2"
  end

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

  # install gdal first so it gets installed via binary package instead of built
  # from source with postgis below
  package "sci-libs/gdal" do
    version gdal_version
    action :install
  end

  execute "setting emerge options" do
    command "emerge --ignore-default-opts dev-db/postgis"
  end
end
