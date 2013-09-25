# fill in missing information below

# if you want to have more than one tunnel set up on a given instance
# (which should be fairly rare) then copy the entire cookbook with a
# different top level name (don't change any filenames in it) and change 
# this value to match before deploying.  Oh, and be sure to add a include_recipe 
# line with the new cookbook name to the main cookbook's default.rb recipe file
default['ssh_tunnel']['tunnel_name'] = 'ssh_tunnel'

default['ssh_tunnel']['instance_role'] = ''

# the host hostname (an IP will work) to ssh to
default['ssh_tunnel']['hostname'] = ''

# only change this if using a non-default ssh port on the destination host,
# such as when connecting through a gateway
default['ssh_tunnel']['port'] = 22

# the system user account to use when logging into the destination host
default['ssh_tunnel']['user'] = ''

# the path to the private key on the instance the tunnel is from
default['ssh_tunnel']['private_key'] = ''

# the path to the public key on the instance the tunnel is from
default['ssh_tunnel']['public_key'] = ''

# the port that will be being forwarded
default['ssh_tunnel']['connect_port'] = ''

# the host on the remote side (or local side for a reverse tunnel) 
# that the :connect_port will be forwarded to
default['ssh_tunnel']['forward_host'] = ''

# the port on :forward_host that :connect_port will be forwarded to
default['ssh_tunnel']['forward_port'] = ''

# valid values: FWD, REV, DUAL. Determines what kind of tunnel(s) to create
# DUAL means create both a forward and reverse tunnel
default['ssh_tunnel']['tunnel_direction'] = ''

# the path to the ssh executable to use when making the ssh connection
default['ssh_tunnel']['ssh_command'] = '/usr/bin/ssh'

# whether or not to use StrictHostKeyChecking when making the ssh connection
default['ssh_tunnel']['skip_hostkey_auth'] = false

# the path to the known hosts file with the public key of the remote server
# only set if :skip_hostkey_auth is set to false
# note that if :skip_hostkey_auth is set to true then you need to make a
# manual connection to the remote host *before* deploying this recipe
# and use the path to the known_hosts file that the remote host's public 
# key is written to here.  It's also even better to copy that key entry to 
# a file somewhere on an EBS volume and use that file's path here to ensure
# that it won't be wiped after an instance restart (terminate and rebuild)
default['ssh_tunnel']['ssh_known_hosts'] = ''