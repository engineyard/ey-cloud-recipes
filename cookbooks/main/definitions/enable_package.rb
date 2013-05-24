define :enable_package, :version => nil, :override_hardmask => false do
  # calculate full name
  full_name = [params[:name], params[:version]].compact.join('-')

  # override mask
  path = "/etc/portage/package.keywords/local"
  
  update_file "unmasking #{full_name}" do
    action :append
    path path
    body "=#{full_name}"
    not_if "grep '=#{full_name}' #{path}"
  end

  # override hard mask
  if params[:override_hardmask]
    path = "/etc/portage/package.unmask/engineyard_overrides"
    
    update_file "overriding hard mask for #{full_name}" do
      action :append
      path path
      body "=#{full_name}"
      not_if "grep '=#{full_name}' #{path}"
    end
  end
end
