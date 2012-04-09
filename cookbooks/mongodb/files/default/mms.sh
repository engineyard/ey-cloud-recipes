#!/bin/bash
# This wrapper file is necessary to drop a pid file to play nice with monit
case $1 in
  start)
     echo $$ > /var/run/mms.pid;
     exec 2>&1 /usr/bin/python /db/mms/mms-agent/agent.py > /db/mms/agent.log 2>&1
     ;;
   stop)  
     kill `cat /var/run/mms.pid` ;;
   *)  
     echo "usage: mms.sh {start|stop}" ;;
esac
exit 0