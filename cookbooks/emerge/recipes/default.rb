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
