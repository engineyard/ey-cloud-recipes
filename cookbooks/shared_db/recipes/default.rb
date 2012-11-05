#
# Cookbook Name:: shared_db
# Recipe:: default
#
# Adapted from https://github.com/omgitsads/ey-cloud-recipes/blob/shared-db/cookbooks/shared-db/recipes/default.rb
# by Adam Holt (@omgitsads)
#

# Name of the application
app = "myapp"
app_path = "/data/#{app}/shared/config/database.yml"

# The name of the application with db credentials you want to use
parent_app = "parentapp"
parent_app_path = "/data/#{parent_app}/shared/config/database.yml"

if app && parent_app
  execute "Symlink #{parent_app_path} to #{app_path}" do
    command "ln -sf #{parent_app_path} #{app_path}"
    only_if "test -f #{parent_app_path}"
  end
end
