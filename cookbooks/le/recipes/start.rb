
# Cookbook Name:: le
# Recipe:: start
#

# Restart the le agent
execute 'start le agent' do
	command %{/etc/init.d/logentries restart}
end
