name             'ssh_tunnel'
maintainer       'Engine Yard'
maintainer_email 'info@engineyard.com'
license          'All rights reserved'
description      'Configures an SSH tunnel on Engine Yard Cloud'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

recipe 'ssh_tunnel', 'Configures an SSH tunnel on Engine Yard Cloud depending on the defined attributes'

attribute 'ssh_tunnel/tunnel_name',
  :display_name => 'SSH Tunnel Name',
  :description  => 'Name of the SSH tunnel',
  :default      => 'ssh_tunnel'

attribute 'ssh_tunnel/instance_role',
  :display_name => 'SSH Tunnel Instance Role',
  :description  => 'The role of the instance on which to set up the tunnel'

attribute 'ssh_tunnel/hostname',
  :display_name => 'SSH Tunnel Hostname',
  :description  => 'The host hostname (an IP will work) to ssh to'
  
attribute 'ssh_tunnel/port',
  :display_name => 'SSH Tunnel Port',
  :description  => 'Default ssh port on the destination host',
  :default      => '22'
  
attribute 'ssh_tunnel/user',
  :display_name => 'SSH Tunnel User',
  :description  => 'The system user account to use when logging into the destination host'
  
attribute 'ssh_tunnel/private_key',
  :display_name => 'SSH Tunnel Private Key',
  :description  => 'The path to the private key on the instance the tunnel is from'
  
attribute 'ssh_tunnel/public_key',
  :display_name => 'SSH Tunnel Public Key',
  :description  => 'The path to the public key on the instance the tunnel is from'
  
attribute 'ssh_tunnel/connect_port',
  :display_name => 'SSH Tunnel Connect Port',
  :description  => 'The port that will be forwarded'
  
attribute 'ssh_tunnel/forward_host',
  :display_name => 'SSH Tunnel Forward Host',
  :description  => 'The host on the remote side (or local side for a reverse tunnel) that the :connect_port will be forwarded to'
  
attribute 'ssh_tunnel/forward_port',
  :display_name => 'SSH Tunnel Forward Port',
  :description  => 'The port on :forward_host that :connect_port will be forwarded to'
  
attribute 'ssh_tunnel/tunnel_direction',
  :display_name => 'SSH Tunnel Direction',
  :description  => 'Determines what kind of tunnel(s) to create. DUAL means create both a forward and reverse tunnel',
  :choice       => \['FWD', 'REV', 'DUAL'\]
  
attribute 'ssh_tunnel/ssh_command',
  :display_name => 'SSH Tunnel Command',
  :description  => 'The path to the SSH executable to use when making the SSH connection',
  :default      => '/usr/bin/ssh'
  
attribute 'ssh_tunnel/skip_hostkey_auth',
  :display_name => 'SSH Tunnel Skip Hostkey Auth',
  :description  => 'Whether or not to use StrictHostKeyChecking when making the ssh connection',
  :default      => 'false'
  
attribute 'ssh_tunnel/ssh_known_hosts',
  :display_name => 'SSH Tunnel Known Hosts',
  :description  => 'The path to the known hosts file with the public key of the remote server'
  