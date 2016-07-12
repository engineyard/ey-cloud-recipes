#Update imagemagick and install policy patch

ey_cloud_report "imagemagick-install" do
  message "Installing php imagemagick security update}"
end


portage_files = [
  "/etc/portage/package.keywords/imagemagickkeywords",
  "/etc/portage/package.unmask/imagemagickunmask"
]

portage_files.each do |portage_file|
  remote_file portage_file do
    source File.basename(portage_file)
    backup 0
    owner "portage"
    group "portage"
    mode 0644
  end
end

if Chef::VERSION == '10.34.6'
  enable_package "media-libs/openjpeg" do
    version "2.1.0"
  end
  package "media-libs/openjpeg" do
    version "2.1.0"
    action :install
  end
end


enable_package "media-libs/lcms" do
  version "2.3"
end


enable_package "media-gfx/imagemagick" do
  version "6.9.0.3-r1"
end

package "media-gfx/imagemagick" do
  version "6.9.0.3-r1"
  action :install
end

remote_file "/etc/ImageMagick-6/policy.xml" do
  source "policy.xml"
  owner "root"
  group "root"
  mode 0644
  backup 0
end
