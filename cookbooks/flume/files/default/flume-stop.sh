# flume-stop.sh
/bin/kill `ps aux | grep [a]pache-flume | awk -F ' ' '{print $2}'`
