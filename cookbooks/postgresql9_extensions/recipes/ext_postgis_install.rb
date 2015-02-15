if @node[:postgres_version] == 9.0
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
elsif @node[:postgres_version] >= 9.1
  postgis_version = "1.5.8"
  proj_version = "4.6.1"
  geos_version = "3.3.5"

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
  
  package "sci-libs/geos" do
    version geos_version
  end

  execute "setting emerge options" do
    command "emerge --ignore-default-opts --noreplace =dev-db/postgis-#{postgis_version}"
  end
end



