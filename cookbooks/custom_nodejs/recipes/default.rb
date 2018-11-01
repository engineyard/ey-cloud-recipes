version = node[:custom_node_version].strip

ey_cloud_report "Install node-v#{version}" do
  message "Installing custom node-v#{version}"
end

Chef::Log.info "Installing custom node-v#{version}"

ebuild_file = "/engineyard/portage/engineyard/net-libs/nodejs-bin/nodejs-bin-#{version}.ebuild"

#create the new nodejs ebuild
remote_file ebuild_file do
  source "nodejs-bin-generic.ebuild"
  backup 0
  mode 0644
end

#create the manifest file
execute "ebuild-nodejs" do
  cwd "/engineyard/portage/engineyard/net-libs/nodejs-bin/"
  command "ebuild #{File.basename(ebuild_file)} manifest"
end


execute "eix-sync" do
  command "eix-sync"
end

#inform the OS of the new package
execute "egencache + eix-update" do
    command "egencache --repo engineyard --update && eix-update"
end

#unmask the new node package
enable_package "net-libs/nodejs-bin" do
    version "#{version}"
end

#install the new node package
package "net-libs/nodejs-bin" do
    version version "#{version}"
    action :install
end

#select the new node version
execute "eselect nodejs-bin-#{version}" do
  command "eselect nodejs set #{version}"
end