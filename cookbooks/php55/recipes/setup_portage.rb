# Prime Portage to compile PHP 5.5.x
# Copy distfiles so Portage doesn't need to download

ey_cloud_report "php#{node[:php][:short_version]}-install" do
  message "Installing php #{node[:php][:short_version]}"
end

portage_files = [
  "/engineyard/portage/dev-libs/libpcre/libpcre-#{node[:php][:pcre_version]}.ebuild",
  "/engineyard/portage/app-admin/eselect-php/eselect-php-#{node[:php][:eselect_php_version]}.ebuild",
  "/engineyard/portage/engineyard/dev-lang/php/php-#{node[:php][:version]}.ebuild",
  "/etc/portage/package.keywords/php55keywords",
  "/etc/portage/package.unmask/php55unmask",
  "/etc/portage/package.use/php55use"
]

binary_files = [
  "/engineyard/portage/distfiles/php-#{node[:php][:version]}.tar.bz2",
  "/engineyard/portage/packages/dev-lang/php-#{node[:php][:version]}.tbz2",
  "/engineyard/portage/distfiles/eselect-php-#{node[:php][:eselect_php_version]}.bz2",
  "/engineyard/portage/packages/app-admin/eselect-php-#{node[:php][:eselect_php_version]}.tbz2",
  "/engineyard/portage/distfiles/pcre-#{node[:php][:pcre_version]}.tar.bz2",
  "/engineyard/portage/packages/dev-libs/libpcre-#{node[:php][:pcre_version]}.tbz2"
]

directory "/engineyard/portage/packages/dev-libs" do
  recursive true
  action :create
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
end

directory "/engineyard/portage/packages/dev-lang" do
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

binary_files.each do |binary_file|
  remote_file binary_file do
    source "#{node[:php][:binary_files_url]}/#{binary_file.split("/").last}"
    backup 0
    owner "portage"
    group "portage"
    mode 0644
  end
end

execute "ebuild-libpcre" do
  cwd "/engineyard/portage/dev-libs/libpcre/"
  command "ebuild libpcre-8.32.ebuild manifest"
end

execute "ebuild-eselect" do
  cwd "/engineyard/portage/app-admin/eselect-php/"
  command "ebuild eselect-php-0.7.0.ebuild manifest"
end

execute "ebuild-php" do
  cwd "/engineyard/portage/engineyard/dev-lang/php/"
  command "ebuild php-#{node[:php][:version]}.ebuild manifest"
end

enable_package "dev-lang/php" do
  version "#{node[:php][:version]}"
end

execute "install-php55" do
  cwd "/root"
  command "emerge -g -n --color n --nospinner =dev-lang/php-#{node[:php][:version]}"
end

# Fix for Archive_Tar bug in PHP 5.5.8
remote_file '/usr/share/php/Archive/Tar.php' do
  source "Archive_Tar.php"
  backup 0
  owner "root"
  group "root"
  mode 0644
  action :nothing
end.run_action(:create)
