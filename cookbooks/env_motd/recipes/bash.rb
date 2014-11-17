
# We're going to need net/http to initiate an HTTP request to AWS.
require 'net/http'

# Start by running on all machines. We do this by simply
# omitting the if/unless logic. We want this on all machines in our
# environment, don't we?

# Put something in the Chef log

ey_cloud_report "Bash-custom" do
  message "Customizing bash shell"
end

Chef::Log.info "Parsing and writing out custom .bashrc for deploy..."

public_hostname = ''

# Grab the public hostname for this instance. This recipe
# will be run *from* the instance, which means that the following
# IP address will be resolved internally from Amazon, which
# is good because it's an Amazon-specific, internal IP
# that they use for instance metadata.
# ########
# This line can take some time, so sometimes it's better to comment it!
# ########
public_hostname = Net::HTTP.get(URI('http://169.254.169.254/latest/meta-data/public-hostname'))

template "/home/deploy/.bashrc" do
  action :create # overwrites if existing
  owner  "deploy"
  group  "deploy"
  mode   0640 # deploy can read/write, deploy's group can read, no one else can do anything
  source "bashrc.erb"
  variables({
    :name => node[:name],
    :role => node[:instance_role],
    :env_name => node[:environment][:name],
    :public_hostname => public_hostname
  })
end
