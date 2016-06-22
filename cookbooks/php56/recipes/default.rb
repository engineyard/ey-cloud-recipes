
if app_server? || util?
  include_recipe "php56::install"
  include_recipe "php56::newrelic"
end
