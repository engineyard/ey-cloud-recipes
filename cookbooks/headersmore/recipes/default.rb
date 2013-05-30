#
# Cookbook Name:: Headersmore Fingerprinting
# Recipe:: Headersmore nginx Fingerprinting script
#
if ['app_master', 'app', 'solo'].include?(node[:instance_role])
	execute "update http-custom.conf" do
		command "
	cat >> http-custom.conf << EOF
	#********************************************************************
	# Headersmore Nginx Fingerprinting header removal
	#********************************************************************
	#
	# Clear Server Header
	more_clear_headers 'Server';

	# Clear X-Powered-By header
	more_clear_headers 'X-Powered-By';"
	  cwd "/etc/nginx/"
	  not_if 'grep more_clear_headers /etc//http-custom.conf'
	end

	execute "reload " do
		command 'sudo /etc/init.d/nginx restart'
	end
end

  


