define :enable_package, :version => nil, :override_hardmask => false do
  name = params[:name]
  version = params[:version]
  full_name = if version
    [name, version].join('-')
  else
    name
  end

  if params[:override_hardmask]
    update_file "add #{full_name} to package.unmask" do
      action :rewrite
      path "/etc/portage/package.unmask/#{full_name.gsub(/\W/, '_')}"
      body "=#{full_name}"
    end
  else
    # won't override a hard-mask
    update_file "add #{full_name} to package.keywords" do
      action :append
      path "/etc/portage/package.keywords/local"
      body "=#{full_name}"
      not_if "grep '=#{full_name}' /etc/portage/package.keywords/local"
    end
  end
end
