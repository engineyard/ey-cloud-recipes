#
# Cookbook Name:: fail2ban
# Recipe:: jails
#
#

# We're going to need net/http to initiate an HTTP request to AWS.
require 'net/http'

ey_cloud_report "Fail2Ban-filter-action" do
  message "Fail2Ban action & filter"
end

public_ip = Net::HTTP.get(URI('http://169.254.169.254/latest/meta-data/public-ipv4'))

def pushFile(fileList, type)
	refPath = "#{Chef::Config['file_cache_path']}cookbooks/fail2ban/files"
	files = fileList.select {|w| w[/#{type}\.d/]}
	files.each do |filepath|
		filename = filepath.match(/#{refPath}\/.*\/#{type}\.d\/(.*)/)
		filename = "#{type}.d/#{filename[1]}"
		cookbook_file "/etc/fail2ban/#{filename}" do
			source filename # filename instead of filepath in the case of a platform specific stuff
			owner 'root'
			group 'root'
			mode "0644"
			action :create #:create_if_missing
		end
	end
end

def pushFileTemplates(fileList, type)
	refPath = "#{Chef::Config['file_cache_path']}cookbooks/fail2ban/templates"
	files = fileList.select {|w| w[/#{type}\.d/]}
	files.each do |filepath|
		filename = filepath.match(/#{refPath}\/.*\/#{type}\.d\/(.*)/)
		filename = "#{type}.d/#{filename[1]}"
		template "/etc/fail2ban/#{filename}" do
			source filename
			owner 'root'
			group 'root'
			mode "0644"
			variables({
				:public_ip  => public_ip,
				:private_ip => node['ipaddress'],
				:host       => node['hostname']
			})
			action :create #:create_if_missing
		end
	end
end

# list file to upload for action and filter try for the templates too
# @see http://lists.opscode.com/sympa/arc/chef/2011-09/msg00271.html
#files = run_context.cookbook_collection[ cookbook_name ].template_filenames
#pushFileTemplates(files, 'filter')
#pushFileTemplates(files, 'action')

files = run_context.cookbook_collection[ cookbook_name ].file_filenames
pushFile(files, 'filter')
pushFile(files, 'action')

#
# Now that we have filter and action deployed, we can configure the jail
#

ey_cloud_report "Fail2Ban-jail-conf" do
  message "Fail2Ban jails"
  Chef::Log.info "Fail2Ban jails configuration"
end


template '/etc/fail2ban/jail.local' do
  source 'jail.local.erb'
  action :create
  variables({
    :jails      => node['fail2ban']['jails']['jails'],
    :ignoreip   => node['fail2ban']['jails']['ignoreip'] + ' ' + node['ipaddress'] + ' ' + public_ip,
    :bantime    => node['fail2ban']['jails']['bantime'],
    :findtime   => node['fail2ban']['jails']['findtime'],
    :maxretry   => node['fail2ban']['jails']['maxretry'],
    :backend    => node['fail2ban']['jails']['backend'],
    :mail       => node['fail2ban']['jails']['mail'],
    :usedns     => node['fail2ban']['jails']['usedns'],
    :ignorecommand     => node['fail2ban']['jails']['ignorecommand'],
    :host       => node['hostname'],
    :actions    => node['fail2ban']['jails']['actions'],
    :banaction  => node['fail2ban']['jails']['banaction'],
    :mta        => node['fail2ban']['jails']['mta'],
    :protocol   => node['fail2ban']['jails']['protocol']
  })
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[fail2ban]'
end


#if app_server? || util?
#
#end

# http://serverfault.com/questions/460442/chef-multiple-files-dynamic-template-resource
# http://docs.getchef.com/chef/dsl_recipe.html
