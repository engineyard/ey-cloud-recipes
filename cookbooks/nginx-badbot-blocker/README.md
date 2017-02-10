# Blocking 'bad' bots, referrals, and IPs on Nginx #

This recipe adds configuration for Nginx to block 'bad'  bots, referals, and IPs.  It is based on the files and instructions from https://github.com/mariusv/nginx-badbot-blocker
It can be used also as a generic example on how to change/extend Nginx's config on EY Cloud.

## Configuration ##

File `files/default/blacklist.conf` defines 'bad' bots and unwanted referals  based on HTTP-AGENT.  File `files/default/blockips.conf` lists IPs for denying access.
By default, only 'bad bots' are blocked.  See `files/default/nginx_blocking_append.txt` for details on how to enable the configuration to block referals and IPs.
