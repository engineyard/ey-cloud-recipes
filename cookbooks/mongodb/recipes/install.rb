mongodb_version = node[:mongo_version]

ey_cloud_report "MongoDB" do
  message "installing mongodb #{mongodb_version}"
end

enable_package "dev-db/mongodb-bin" do
  version mongodb_version
end

package "dev-db/mongodb-bin" do
  version mongodb_version
  action :install
end
