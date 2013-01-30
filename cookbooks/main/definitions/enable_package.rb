define :enable_package, :version => nil, :override_hardmask => false do
  name = params[:name]
  version = params[:version]
  full_name = [name, version].compact.join('-')
  
  path = "/etc/portage/package." 
  path << params[:override_hardmask] ? "unmask/engineyard" : "keywords/local"

  update_file "add #{full_name} to #{p}" do
    action :append
    path path
    body "=#{full_name}"
    not_if "grep '=#{full_name}' #{p}"
  end
end
