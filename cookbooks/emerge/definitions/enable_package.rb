define :enable_package, :version => nil, :override_hardmask => false do
  name = params[:name]
  version = params[:version]
  full_name = if version
    [name, version].join('-')
  else
    name
  end

  # won't override a hard-mask
  p = "/etc/portage/package.keywords/local"
  update_file "add #{full_name} to #{p}" do
    action :append
    path p
    body "=#{full_name}"
    not_if "grep '=#{full_name}' #{p}"
  end

  if params[:override_hardmask]
    p = "/etc/portage/package.unmask/engineyard_overrides"
    update_file "add #{full_name} to #{p}" do
      action :append
      path p
      body "=#{full_name}"
      not_if "grep '=#{full_name}' #{p}"
    end
  end
end
