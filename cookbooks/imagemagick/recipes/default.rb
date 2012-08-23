#
# Cookbook Name:: imagemagick
# Recipe:: default
#

enable_package "media-gfx/imagemagick" do
  version "6.4.9.2"
end

package "media-gfx/imagemagick" do
  version "6.4.9.2"
  action :install 
end