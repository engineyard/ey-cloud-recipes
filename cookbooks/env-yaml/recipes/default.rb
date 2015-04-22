# --
# General configuration
# --

# By default, it will create a file named env.yml -- change this if you need a
# different name in case of conflicts
basename = 'env' 

# Defaults -- applies to all configurations, can be overwritten by
# namespaces-specific configurations -- set to {} or nil if not used.
defaults = {
  'VAR1' => 'value1',
  'VAR2' => 'value2' #...
}

# Namespaced values - associate values with specific Rails environments
namespaces = {
  :production => {
    'VAR1' => 'value1a',
    #...
  },
  :staging => {
    'VAR1' => 'value1b',
    #...
  },
  #...
}

# --
# Main
# --

# This recipe only applies to instances that have /data/ mounted
if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])

  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/#{basename}.yml"do
      source 'env.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
      variables(
        :defaults => defaults,
        :namespaces => namespaces
      )
    end
  end
end
