ey_cloud_report "clamav#{node[:clamav][:short_version]}-install" do
  message "Installing clamav #{node[:clamav][:short_version]}"
end

portage_files = [
  "/engineyard/portage/engineyard/app-antivirus/clamav/clamav-#{node[:clamav][:version]}.ebuild",
  "/etc/portage/package.keywords/clamavkeywords",
  "/etc/portage/package.unmask/clamavunmask",
  "/engineyard/portage/engineyard/app-antivirus/clamav/files/clamd_at.service",
  "/engineyard/portage/engineyard/app-antivirus/clamav/files/clamd.conf-r1",
  "/engineyard/portage/engineyard/app-antivirus/clamav/files/clamd.initd-r6",
  "/engineyard/portage/engineyard/app-antivirus/clamav/files/clamd.service",
  "/engineyard/portage/engineyard/app-antivirus/clamav/files/freshclamd.service"
]

binary_files = [
  "/engineyard/portage/packages/app-antivirus/clamav-#{node[:clamav][:version]}.tbz2"
]


directory "/engineyard/portage/packages/app-antivirus" do
  recursive true
  action :create
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
end

directory "/engineyard/portage/engineyard/app-antivirus/clamav/files/tmpfiles.d" do
  recursive true
  action :create
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
end

# Copy Source Files if they are not already there
portage_files.each do |portage_file|
  remote_file portage_file do
    source File.basename(portage_file)
    backup 0
    owner "portage"
    group "portage"
    mode 0644
  end
end

cookbook_file '/engineyard/portage/engineyard/app-antivirus/clamav/files/tmpfiles.d/clamav.conf' do 
    source 'tmpfiles.d/clamav.conf'
    backup 0
    owner "portage"
    group "portage"
    mode 0644
end

binary_files.each do |binary_file|
  remote_file binary_file do
    source "#{binary_file.split("/").last}"
    backup 0
    owner "portage"
    group "portage"
    mode 0644
  end
end


execute "ebuild-clamav" do
  cwd "/engineyard/portage/engineyard/app-antivirus/clamav/"
  command "ebuild clamav-#{node[:clamav][:version]}.ebuild manifest"
end

enable_package "app-antivirus/clamav" do
  version "#{node[:clamav][:version]}"
end

execute "install-clamav" do
  cwd "/root"
  command "emerge -g -n --color n --nospinner =app-antivirus/clamav-#{node[:clamav][:version]}"
end


