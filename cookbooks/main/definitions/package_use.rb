define :package_use, :flags => nil do
  file "/etc/portage/package.use" do
    action :delete
    not_if "file -d /etc/portage/package.use"
  end

  directory "/etc/portage/package.use" do
    action :create
  end

  execute "touch /etc/portage/package.use/local" do
    action :run
    not_if "test -f /etc/portage/package.use/local"
  end

  update_file "local portage package.use" do
    path "/etc/portage/package.use/local"
    body [params[:name], params[:flags]].compact.join(' ')
    not_if "grep '#{full_name}' /etc/portage/package.use/local"
  end
end
