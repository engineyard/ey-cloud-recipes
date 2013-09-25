# Description

Use this recipe to set up an SSH tunnel on Engine Yard Cloud instances. Some
use cases for SSH tunnels may be the following:

- Connect your application to a remote database
- To set up a [SOCKS proxy](http://en.wikipedia.org/wiki/SOCKS)

# Requirements

## Attributes

The node attributes for this cookbook are located in the `attributes/` folder.
They can be set by modifying them directly though it would be better practice
to override them in the "main" cookbook using

```
node.override['ssh_tunnel']['attribute'] = <value>
```

### default.rb

- `node['ssh_tunnel']['tunnel_name']` - If you want to have more than one tunnel set up on a given instance (which should be fairly rare) then copy the entire cookbook with a different top level name (don't change any filenames in it) and change this value to match before deploying. Oh, and be sure to add an `include_recipe` line with the new cookbook name to the main cookbook's default.rb recipe file. Defaults to "ssh_tunnel"
- `node['ssh_tunnel']['instance_role']` - The role of the instance on which to set up the tunnel. Values can be "solo", "app_master", "app", "util", "db_master", "db_slave"
- `node['ssh_tunnel']['hostname']` - The host hostname (an IP will work) to ssh to
- `node['ssh_tunnel']['port']` - Default ssh port on the destination host. Defaults to "22"
- `node['ssh_tunnel']['user']` - The system user account to use when logging into the destination host
- `node['ssh_tunnel']['private_key']` - The path to the private key on the instance the tunnel is from
- `node['ssh_tunnel']['public_key']` - The path to the public key on the instance the tunnel is from
- `node['ssh_tunnel']['connect_port']` - The port that will be forwarded
- `node['ssh_tunnel']['forward_host']` - The host on the remote side (or local side for a reverse tunnel) that the `:connect_port` will be forwarded to
- `node['ssh_tunnel']['forward_port']` - The port on `:forward_host` that `:connect_port` will be forwarded to
- `node['ssh_tunnel']['tunnel_direction']` - Determines what kind of tunnel(s) to create. DUAL means create both a forward and reverse tunnel. Values can be "FWD", "REV", or "DUAL"
- `node['ssh_tunnel']['ssh_command']` - The path to the SSH executable to use when making the SSH connection. Defaults to `/usr/bin/ssh`
- `node['ssh_tunnel']['skip_hostkey_auth']` - Whether or not to use StrictHostKeyChecking when making the ssh connection. Defaults to `false`
- `node['ssh_tunnel']['ssh_known_hosts']` - The path to the known hosts file with the public key of the remote server only set if `:skip_hostkey_auth` is set to false. Note that if `:skip_hostkey_auth` is set to true then you need to make a manual connection to the remote host *before* deploying this recipe and use the path to the known_hosts file that the remote host's public key is written to here.  It's also even better to copy that key entry to a file somewhere on an EBS volume and use that file's path here to ensure that it won't be wiped after an instance restart (terminate and rebuild).

## Recipes

This cookbook provides the following recipe for setting up an SSH tunnel:

- default.rb: Use this recipe to configure the SSH tunnel which will be monitored by Monit

### default.rb

The default recipe will create the `ssh_tunnel` init file in the `/etc/init.d` directory that
sets up the SSH tunnel. It also drops a `ssh_tunnel.monitrc` file in the `/etc/monit.d`
directory that will be picked by Monit after it is restarted.

## Usage

Uncomment the `include_recipe 'ssh_tunnel'` line in the `cookbooks/main/recipes/default.rb`
file. Modify the attributes as needed to change how the tunnel is configured.
