# Cookbook: api-keys-yml
# Recipe: default

# Only add configuration to Application or Utility servers
if util_or_app_server?

	# Write configuration for each application in the environment
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/api-keys.yml"do
      source 'api-keys.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0655
      backup 0
      # Pass a hash of variables to the method below and they will be available
			# as local variables in the templates/default/api-keys.yml.erb template
			# Example:
      #		variables({
			#			:aws_access_key	=> 'xxx',
			#			:aws_secret_key => 'yyy'
			#		})
    end
  end
end
