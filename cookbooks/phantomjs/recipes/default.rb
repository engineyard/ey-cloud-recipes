begin
  include_recipe "phantomjs::#{node['phantomjs']['install_method']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.warn "`#{node['phantomjs']['install_method']}` is not a supported install method for phantomjs!"
end
