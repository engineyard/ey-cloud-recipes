define :package_use, :flags => nil do
  name = params[:name]
  flags = params[:flags]
  full_name = name + (" #{flags}" if flags)

  file "/etc/portage/package.use" do
    action :delete

    not_if "file -d /etc/portage/package.use"
  end

  directory "/etc/portage/package.use" do
    action :create
  end

  execute "touch /etc/portage/package.use/local" do
    action :run
    not_if { FileTest.exists?("/etc/portage/package.use/local") }
  end

  update_file "local portage package.use" do
    path "/etc/portage/package.use/local"
    body full_name
    not_if "grep '#{full_name}' /etc/portage/package.use/local"
  end
end
