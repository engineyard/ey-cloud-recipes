#!/bin/bash

case $1 in
  start)
     echo $$ > /home/deploy/datadog/.datadog-agent/run/datadog_wrapper.pid
     /bin/bash /home/deploy/datadog/.datadog-agent/bin/agent start
     ;;
   stop)
     kill `cat /home/deploy/datadog/.datadog-agent/run/datadog_wrapper.pid`
     kill `cat /home/deploy/datadog/.datadog-agent/run/supervisord.pid`
     ;;
   *)
     echo "usage: datadog_wrapper {start|stop}" ;;
esac
exit 0
