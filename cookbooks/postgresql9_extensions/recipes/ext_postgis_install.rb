if @node[:postgres_version] == "9.0"
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
elsif ["9.1"].include?(@node[:postgres_version])
  postgis_version = "1.5.3-r1"

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

  execute "setting emerge options" do
    command "emerge --ignore-default-opts dev-db/postgis"
  end
end



