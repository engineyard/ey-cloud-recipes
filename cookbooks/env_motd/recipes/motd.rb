
# We're going to need net/http to initiate an HTTP request to AWS.
require 'net/http'

ey_cloud_report "motd-custom" do
  message "Customizing welcome message"
end

Chef::Log.info "Parsing and writing out custom motd for deploy..."

public_hostname = ''
public_ip = ''

# Grab the public hostname for this instance. This recipe
# will be run *from* the instance, which means that the following
# IP address will be resolved internally from Amazon, which
# is good because it's an Amazon-specific, internal IP
# that they use for instance metadata.
# ########
# This two lines can take some time, so sometimes it's better to comment it!
# ########
public_hostname = Net::HTTP.get(URI('http://169.254.169.254/latest/meta-data/public-hostname'))
public_ip = Net::HTTP.get(URI('http://169.254.169.254/latest/meta-data/public-ipv4'))

template "/home/deploy/.welcome-info.sh" do
  action :create # overwrites if existing
  owner  "deploy"
  group  "deploy"
  mode   0640
  source "motd.erb"
  variables({
    :name => node[:name],
    :role => node[:instance_role],
    :env_name => node[:environment][:name],
    :public_hostname => public_hostname,
    :public_ip => public_ip
  })
end

execute "bash_profile-push_welcome-message" do
	command "echo 'sh /home/deploy/.welcome-info.sh' >> /home/deploy/.bash_profile"
	not_if 'grep "sh /home/deploy/.welcome-info.sh" /home/deploy/.bash_profile'
end
