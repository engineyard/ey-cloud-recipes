
if app_server? || util?
  include_recipe "php55::install"
  include_recipe "php55::newrelic"
end
