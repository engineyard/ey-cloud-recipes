#!/bin/sh

echo ''
echo '-[====]-'

let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

MEM_FREE=$(free -m | head -n 2 | tail -n 1 | awk {'print $4'})
MEM_TOTAL=$(free -m | head -n 2 | tail -n 1 | awk {'print $2'})
MEM_CACHE=$(free -m | head -n 2 | tail -n 1 | awk {'print $7'})
MEM_SWAP=$(free -m | tail -n 1 | awk {'print $3'})

echo "$(tput setaf 2)
`date +"%A, %e %B %Y, %r"`
`uname -srmo`$(tput setaf 1)

Uptime.............: ${UPTIME}
Memory.............: ${MEM_FREE} Mb (Free) / ${MEM_TOTAL}Mb (Total) with ${MEM_CACHE}Mb (cache) and ${MEM_SWAP}Mb (swap)
Load Averages......: `cat /proc/loadavg |cut -d ' ' -f1-3` (1, 5 and 15 min)
Running Processes..: `ps ax | wc -l`
Disk Space.........: `df / -h |tail -1|awk {'print $4 "/" $2 " (" $5 ")"'}`

IP Addresses.......: `ifconfig eth0|head -2|tail -1|awk {'print $2'}`
Server Name........: `hostname`
Public Name........: <%= @public_hostname %>
Public Ip..........: <%= @public_ip %>

Ey info............: <%= @role %>/<%= @env_name %>
$(tput sgr0)"

echo '-[====]-'
echo ''
