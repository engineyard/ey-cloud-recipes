# as opposed to the enable_package action, this takes care of both the keywords and the unmask file
# as required in https://support.cloud.engineyard.com/entries/23257737-portage-has-only-masked-and-outdated-versions-of-qt-webkit 
# https://support.cloud.engineyard.com/entries/23257737-portage-has-only-masked-and-outdated-versions-of-qt-webkit

define :enable_package_unmask_and_keywords, :version => nil do
  name = params[:name]
  version = params[:version]
  full_name = name

  update_file "local portage package.keywords" do
    path "/etc/portage/package.keywords/local"
    body "=#{full_name}"
    not_if "grep '=#{full_name}' /etc/portage/package.keywords/local"
  end
  
  update_file "local portage package.unmask" do
    path "/etc/portage/package.unmask/local"
    body "=#{full_name}"
    not_if "grep '=#{full_name}' /etc/portage/package.unmask/local"
  end
  
end
