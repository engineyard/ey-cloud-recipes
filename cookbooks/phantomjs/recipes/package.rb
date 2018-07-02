# Installs specified PhantomJS version from package

enable_package node['phantomjs']['package_name'] do
  version node['phantomjs']['package_version']
  unmask true
end

package node['phantomjs']['package_name'] do
  version node['phantomjs']['package_version']
  action :install
end
