mongodb_version = node[:mongo_version]
mongodb_package = node[:mongo_package]

ey_cloud_report "MongoDB" do
  message "installing mongodb #{mongodb_version}"
end

enable_package "#{mongodb_package}" do
  version mongodb_version
end

remote_file "/etc/portage/package.keywords/mongodb" do
  source "mongodb.keywords"
  backup 0
  mode 0644
  owner "root"
  group "root"
end

package_remove = mongodb_package == "dev-db/mongodb"? 'dev-db/mongodb-bin' : 'dev-db/mongodb'
package "#{package_remove}" do
  action :remove
end

package "#{mongodb_package}" do
  version mongodb_version
  action :install
end
