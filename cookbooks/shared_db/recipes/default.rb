#
# Cookbook Name:: shared_db
# Recipe:: default
#
# Adapted from https://github.com/omgitsads/ey-cloud-recipes/blob/shared-db/cookbooks/shared-db/recipes/default.rb
# by Adam Holt (@omgitsads)
#

# Array of applications that you wish to write the shared database configuration to
apps = ["myapp"]

# The name of the application with db credentials you want to use
parent_app = "parentapp"
parent_app_path = "/data/#{parent_app}/shared/config/database.yml"

if apps && parent_app
  for app in apps
		execute "Symlink #{parent_app_path} to /data/#{app}/shared/config/database.yml" do
			command "ln -sf #{parent_app_path} /data/#{app}/shared/config/database.yml"
			only_if "test -f #{parent_app_path}"
		end
	end
end
