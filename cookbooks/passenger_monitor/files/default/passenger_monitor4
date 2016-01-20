#!/bin/bash
#===============================================================================
script_name="passenger_monitor"
script_author="James Paterni, Dennis Bell, Jim Neath, Radamanthus Batnag"
script_version="0.1.0"
#===============================================================================
# This script monitors passenger application instances and gracefully restarts
#   any monitored instances exceeding the configured (real) memory limit and
#   kills any orphaned instances
#
# * Ensure this script is executable (chmod +x)
#===============================================================================

target_app=$1

# Check user is root.
if [ "`whoami`" != "root" ]; then
  logger -t `basename $0` -s "Must be run as root"
  exit 1
fi

## Defaults 
# memory limit - override with -l <limit in MB>
# grace time - how long to wait before doing a kill -9 - override with -w <grace_time in seconds>
limit=250
grace_time=30

shift
while getopts "l:w:" opt; do
  case $opt in
    l)
      limit=$OPTARG
      ;;
    w)
      grace_time=$OPTARG
      ;;
  esac
done

let "grace_time=$grace_time*4"

## Get output from passenger-memory-stats, egrep for RailsApp: OR RackApp:.
## Sed explained:
##  /MB/!d; - Do not delete lines with MB in them. All others are removed (check for memory output)
##  s/(^[0-9]+)\s.*(\b[0-9]+)\.[0-9]+\sMB.*MB.*/\1-\2/' ... Explained in segments below...
##      s/ -- Tell sed that this is a search and replace function.
##      ^(^[0-9]+)\s* -- Get the pid (First set of numbers at beginning of string).
##      (\b[0-9]+)\.[0-9]+\sMB\s+ -- Grab the virtual memory for each process. Must begin with a word break (i.e. space), have numbers, a dot, more numbers a space and MB. Only the integer half of the number is grabbed.
##      (\b[0-9]+)\.[0-9]+\sMB -- same thing for the real memory for each process
##      .*\/([^\/]+)\/current -- grab the application name out of the path
##      \1,\2,\3,\4/ -- assembe the selected values into a comma-separated-list, to later be converted into an array

# Create an array variable
declare -a info

for record in `passenger-memory-stats | egrep -i "Passenger Ra(ils|ck)App:" | sed -r '/MB/!d;s/(^[0-9]+)\s*(\b[0-9]+)\.[0-9]\sMB\s+(\b[0-9]+)\.[0-9]+\sMB.*\/([^\/]+)\/current/\1,\2,\3,\4/'`; do

  # Turn the record into an array, and assign to local variables for clarity
  info=(`echo ${record//,/ }`)
  app_pid=${info[0]}
  app_virt=${info[1]} # reserved for future use
  app_real=${info[2]}
  app_name=${info[3]}

  if [[ "$app_name" != "$target_app" ]]; then
    continue
  fi

  ## Check the against the limit, if it exceeds the memory amount, KILL IT.
  if [[ $app_real -gt $limit ]]; then
    logger -t passenger_monitor -s "Killing PID $app_pid (app $app_name) - memory $app_real MB exceeds $limit MB"
    kill -USR1 $app_pid
    SLEEP_COUNT=0
    while [ -e /proc/$app_pid ]; do
      sleep .25
      let "SLEEP_COUNT+=1"
      let "REPORT_TIME = $SLEEP_COUNT%4"
      if(( "$SLEEP_COUNT" > $grace_time )); then
        logger -t passenger_monitor -s "Stopping Passenger worker Process $app_pid wait exceeded, killing it"
        kill -9 $app_pid 2>/dev/null; true
        break
      elif(( $REPORT_TIME == 0 ));then
        let "RUNTIME = $SLEEP_COUNT/4"
        logger -t passenger_monitor -s "Waiting for $app_pid to die ( for $RUNTIME seconds now)"
      fi
    done
  fi
done

## Passenger 2 stale passenger.<x> fix:
## Remove stale passenger.<x> directories to prevent
## multiple passenger instance running error.
for each in /tmp/passenger.*;do 
  if [[ -d ${each}/info ]]; then  # This is passenger 2?
    if [[ ! -e ${each}/info/status.socket ]]; then  # Remove stale directories.
      rm -rf ${each}
    fi
  fi
done

## Get a list of passenger workers.
raw_stats=$(/usr/sbin/passenger-status 2>> /tmp/passenger_errors)
exit_code=$?

## Kill any passenger workers that are not in $pstats
if [ "$exit_code" -eq "0" ] ; then
  pstats=$(echo "$raw_stats" | sed -r -e '/PID:/!d' -e 's/.*PID:\s([0-9]+).*/\1/' | sort -n| uniq)
  for pid in `diff <(ps aux | egrep -i 'Passenger Ra(ils|ck)App:' | awk '{print $2}' | sort -n) <(echo "$pstats") | grep '<' | awk '{print $2}'`; do
    kill -9 $pid
    logger -t passenger_monitor -s "Killing PID $pid - orphaned process"
  done
else
  logger -t passenger_monitor -s "Could not read passenger-status [Status:$exit_code]"
  logger -t passenger_monitor -s "$raw_stats"
fi
