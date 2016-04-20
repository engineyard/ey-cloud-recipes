if app_server? || util?
  include_recipe "clamav::install"
end
