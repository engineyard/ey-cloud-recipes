if @node[:postgres_version] >= 9.2
  proj_version = "4.6.1"
  geos_version = "3.4.2"
  python_exec_version = "0.2"

  if ey_release_version == '2009a'
    gdal_version = "1.10.0"
    postgis_version = "2.1.1-r1"

    enable_package "dev-libs/json-c" do
      version "0.11"
    end
  else
    gdal_version = "1.10.0-r1"
    postgis_version = "2.1.5"
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

  enable_package "dev-python/python-exec" do
    version python_exec_version
  end

  # normal install case
  package "dev-db/postgis" do
    version postgis_version
    action :install
  end
end
