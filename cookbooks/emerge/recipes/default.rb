#############################################
# Sample recipe for emerging packages
# 
# Search the Engine Yard portage tree to find
# out package versions to install
#
# EXAMPLE:
#
# Ensure local package index is synced with tree
# $ eix-sync
#
# Search for libxml2
# $ eix libxml2
#############################################

# Unmask version 2.7.6 of libxml2
# enable_package "dev-libs/libxml2" do
#   version "2.7.6"
# end

# Install the newly unmasked version
# package "dev-libs/libxml2" do
#   version "2.7.6"
#   action :install
# end


# DC Uses capybara-webkit which requires qt-webkit (normally masked in Gentoo)

packages_to_unmask = %w[qt-core qt-gui qt-phonon qt-script qt-webkit qt-xmlpatterns qt-qt3support]

packages_to_unmask.each do |package|
  enable_package "x11-libs/#{package}" do
    version "4.7.3"
    override_hardmask true
  end
end

package "x11-libs/qt-webkit" do
  version "4.7.3"
  action :install
end

