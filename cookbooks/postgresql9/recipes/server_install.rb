postgres_version = '9.0.2'

%w{dev-db/postgresql-base dev-db/postgresql-server}.each do |p|
  enable_package p do
    version postgres_version
  end
end

package "dev-db/postgresql-base" do
  version "9.0.2"
  action :install
end

package "dev-db/postgresql-server" do
  version "9.0.2"
  action :install
end
