mongodb_version = node[:mongo_version]

ey_cloud_report "MongoDB" do
  message "installing mongodb #{mongodb_version}"
end

enable_package "dev-db/mongodb" do
  version mongodb_version
end

remote_file "/etc/portage/package.keywords/mongodb" do
  source "mongodb.keywords"
  backup 0
  mode 0644
  owner "root"
  group "root"
end

package "dev-db/mongodb" do
  version mongodb_version
  action :install
end
