define :s3_forceinstall, :atom => nil do
  version = params[:version]
  name = params[:name]
  atom = `echo #{name} | cut -d '/' -f 1`.chomp
  full_name = name + '-' + version

  directory "/engineyard/portage/packages" do
    action :create
    mode 0755
    owner "root"
    group "root"
  end

  directory "/engineyard/portage/packages/#{atom}" do
    action :create
    mode 0755
    owner "root"
    group "root"
  end

  execute "remove old package file" do
    command "rm /engineyard/portage/packages/#{full_name}.tbz2"
    only_if { File.exists?("/engineyard/portage/packages/#{full_name}.tbz2") }
  end

  remote_file "/engineyard/portage/packages/#{full_name}.tbz2" do
    source "http://ey-portage.s3.amazonaws.com/#{node[:kernel][:machine]}/#{full_name}.tbz2"
    not_if { FileTest.exists?("/engineyard/portage/packages/#{full_name}.tbz2") }
    backup false
  end

  execute "emerge --ignore-default-opts /engineyard/portage/packages/#{full_name}.tbz2" do
    action :run
  end
  
end
