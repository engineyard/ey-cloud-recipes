define :enable_package, :version => nil do
  name = params[:name]
  version = params[:version]
  full_name = if version
    [name, version].join('-')
  else
    name
  end

  update_file "local portage package.keywords" do
    path "/etc/portage/package.keywords/local"
    body "=#{full_name}"
    not_if "grep '=#{full_name}' /etc/portage/package.keywords/local"
  end
end
