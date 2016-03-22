
if app_server? || util?
  include_recipe "php55::setup_portage"
  include_recipe "php55::select_version"
  include_recipe "php55::newrelic"
end
