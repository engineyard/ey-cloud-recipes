# sets use flags for packages
define :package_use, :flags => nil do
  # full package name
  full_name = [params[:name], params[:flags]].compact.join(' ')

  # delete package.use file
  file "/etc/portage/package.use" do
    action :delete
    not_if "file -d /etc/portage/package.use"
  end

  # recreate package.use as directory
  directory "/etc/portage/package.use" do
    action :create
  end

  # create local file 
  execute "touch /etc/portage/package.use/local" do
    action :run
    not_if "test -f /etc/portage/package.use/local"
  end

  # write flags to local use file
  update_file "local portage package.use" do
    path "/etc/portage/package.use/local"
    body full_name
    not_if "grep '#{full_name}' /etc/portage/package.use/local"
  end
end
