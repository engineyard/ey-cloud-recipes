include NodeJs::Helper

use_inline_resources if defined?(use_inline_resources)

action :install do
  execute "install NPM package #{new_resource.name}" do
    cwd new_resource.path
    command "npm install #{npm_options}"
    user new_resource.user
    group new_resource.group
    environment 'HOME' => ::Dir.home(new_resource.user), 'USER' => new_resource.user if new_resource.user
    not_if { package_installed? }
  end
end

action :uninstall do
  execute "uninstall NPM package #{new_resource.package}" do
    cwd new_resource.path
    command "npm uninstall #{npm_options}"
    user new_resource.user
    group new_resource.group
    environment 'HOME' => ::Dir.home(new_resource.user), 'USER' => new_resource.user if new_resource.user
    only_if { package_installed? }
  end
end

def package_installed?
  new_resource.package && npm_package_installed?(new_resource.package, new_resource.version, new_resource.path)
end

def npm_options
  options = ''
  options << ' -global' unless new_resource.path
  new_resource.options.each do |option|
    options << " #{option}"
  end
  options << " #{npm_package}"
end

def npm_package
  if new_resource.json
    return new_resource.json.is_a?(String) ? new_resource.json : nil
  elsif new_resource.url
    return new_resource.url
  elsif new_resource.package
    return new_resource.version ? "#{new_resource.package}@#{new_resource.version}" : new_resource.package
  else
    Chef::Log.error("No good options found to install #{new_resource.name}")
  end
end

def initialize(*args)
  super
  @run_context.include_recipe 'nodejs::npm'
end
