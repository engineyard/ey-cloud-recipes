if ['app_master', 'app'].include?(node['instance_role'])
  # template for php.ini
  template "/etc/php/fpm-php5.3/php.ini" do
    owner node['owner_name']
    group node['owner_name']
    mode 0644
    source 'php.ini.erb'
    # You can specify variables to be used in php.ini here or just modify the
    # template directly. Variables can then be set in php.ini.erb using ERB tags
    #
    # Example:
    #   # In ini_setup.rb recipe
    #   variables {
    #     :memory_limit => "256M"
    #   }
    #
    #   # In templates/default/php.ini.erb
    #   memory_limit = <%= @memory_limit %>
  end
end