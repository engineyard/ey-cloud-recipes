#
# Cookbook Name:: qt-webkit
# Recipe:: install
#

packages_to_unmask = %w[qt-core-4* qt-gui-4* qt-phonon-4* qt-script-4* qt-webkit-4* qt-xmlpatterns-4* qt-qt3support]

packages_to_unmask.each do |package|
  enable_package_unmask_and_keywords "x11-libs/#{package}" do
    unmask true
  end  
end



package 'x11-libs/qt-webkit' do
  version node[:qt_webkit_version]
  action :install
end
