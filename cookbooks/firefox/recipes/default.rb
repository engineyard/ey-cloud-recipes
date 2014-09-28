#
# Cookbook Name:: firefox
# Recipe:: default
#

if ['app_master', 'app', 'solo', 'util'].include?(node[:instance_role])

  # firefox-bin packages are required to run firefox
  package "www-client/firefox-bin"
  package "www-client/firefox-bin" do
    action :upgrade
  end

  dir_path = "/home/firefoxes"

  directory dir_path do
    owner "root"
    mode "0755"
    action :create
  end

  # all the firefox versions which needs to be downloaded and extracted
  firefox_default_version = node[:firefox][:default_version]
  # all the firefox versions which need to be downloaded and installed
  node[:firefox][:versions] = firefox_default_version | node[:firefox][:other_versions]
  node[:firefox][:versions].each do |firefox_version|
    directory "#{dir_path}/#{firefox_version}" do
      owner "root"
      mode "0755"
      action :create
    end

    firefox = node[:firefox][firefox_version]
    firefox_version_path = "#{dir_path}/#{firefox_version}"
    tar_file = "#{firefox_version_path}/#{firefox[:filename]}"

    remote_file tar_file do
      owner "root"
      source firefox[:url]
      checksum firefox[:sha]
      action :create_if_missing
    end

    bash "untar firefox-#{firefox_version} to #{dir_path}" do
      cwd firefox_version_path
      code <<-EOH
        tar jxf #{tar_file}
      EOH
    end

    link "/usr/bin/firefox#{firefox_version}" do
      to"#{firefox_version_path}/#{firefox[:firefox_dir]}/firefox"
    end
  end

  # the default firefox version is sym linked
  link "/usr/bin/firefox" do
    to"/usr/bin/firefox#{firefox_default_version}"
  end
end
