begin
  include_recipe "casperjs::#{node['casperjs']['install_method']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.warn "`#{node['casperjs']['install_method']}` is not a supported install method for casperjs!"
end
