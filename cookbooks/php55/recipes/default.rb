

# /etc/engineyard/release
# 2012.11.021.final

if app_server? || util?
  include_recipe "php55::setup_portage"
  include_recipe "php55::select_version"
end
