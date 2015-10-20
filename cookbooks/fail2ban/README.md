This cookbook deploy and configure fail2ban on Engine Yard Cloud.
This cookbooks is also the result of the collaboration of the Engine Yard support team andthe BePark team!

replace_line are taken from https://github.com/jenssegers/chef-file

# Description
Deploy & configure fail2ban, a tool that check your logs to detect potential attack and block them with firewall rules.
* auto copy filter and action from chef files
* facilitates the configuration of jails
* facilitates the configuration of action

# Recipes
## default
Deploy & configure fail2ban

# Usage
Add include_recipe "fail2ban" in main cookbook

# Attributes
The attributes file (attributes/default.rb) has enough comment to understand... All the configuration is made there

# Configuration
All configuration can be done by changing attributes/default.rb file but feel free to change anything else!

## Jail configuration
```
[ssh-ddos]
enabled = true
port    = ssh
filter  = sshd-ddos
logpath  = /var/log/auth.log
maxretry = 3
```
will be converted to
```
default['fail2ban']['jails']['jails']['ssh-dos'] = {
	'title'     => 'Protection agains ssh dos attack',
	'comment'   => '',
	'options'   => {
		'enabled'   => 'true',
		'port'      => 'ssh',
		'filter'    => 'sshd-ddos'
		'logpath'   => '/var/log/auth.log',
		'maxretry'  => '3'
	}
}
```
