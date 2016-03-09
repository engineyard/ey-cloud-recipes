#!/bin/bash

case $1 in
  start)
     echo $$ > /var/run/datadog_wrapper.pid
     /bin/bash /root/.datadog-agent/bin/agent start
     ;;
   stop)
     kill `cat /var/run/datadog_wrapper.pid`
     kill `cat /root/.datadog-agent/run/supervisord.pid`
     ;;
   *)
     echo "usage: datadog_wrapper {start|stop}" ;;
esac
exit 0
