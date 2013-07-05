#!/bin/sh
# Shamelessly stolen from the resque wrapper and modified for just scheduler.
#
# This script starts and stops the Resque daemon
# This script belongs in /engineyard/bin/resque
#
# Changes for consideration to resque script:
# * Problems to be solved:
# ** Resque logs overwritten on start and stop (DONE)
# ** Time for worker to stop
#    Its pefrectly reasonable to expect a worker to need several minutes to stop. 
#    In the resque Readme, GH  use resque to archive things and expect it to take 
#    10 minutes for eg. so a variable $WAIT_TIME is set.
# ** Time for a worker to be allowed to run before being regaurded as stale
# ** We need to kill with -QUIT first, before simply trying to terminate with -15
# ** We've found that the process of itterating children and killing (in this case the children
#    are the rake tasks launched by su) is often not working..i.e. they don't die. this needs
#    fixing. Ppl are working around it by killing the su (i.e. the PID in the pid file), but that
#    murders the children suddenly.
# ** ## INVALID ##
#    We'd like to be able to use the COUNT= parameter. This saves some memory (30Mb+ per worker)
#    but strips us of the ability to track the workers by memory, so an accompanying cron script 
#    is required 
#    ## Not going to do this. The resque source code mentions that this is only intended
#    ##for use in development, so who are we to argue!
# ** We'd like to be able to request a sudden death if required
# ** Instancing. We may want > 1 worker instance (which currently equates to a monit stanza)
#    to process a queue. The correct way is prob to have a diff conf for each stanza.
#    Once customer (limos on ey05-s00522) worked around this with an instance parameter.
#    One advantage of this over say having > 1 conf file specfify the same queue, is that 
#    logging is arguably more handy per queue that per conf, and we can't do that by using 
#    several conf files to specfiy 1 queue (as it stands)
# ** Add pause/continue functionality (USR2/CONT)
# ** Add kill child functionality (USR1)
# ** Bug where monit either removes a PID file, or fails to write one, resulting in at least 
#    one rogue worker.<< DONE Hopefuly!

usage() {
  echo "Usage: $0 <appname> {start|stop} <environment>"
  exit 1
}

if [ $# -lt 3 ]; then usage; fi

if [ "`whoami`" != "root" ]; then
  logger -t `basename $0` -s "Must be run as root" 
  exit 1
fi

# Basic setup of default values
APP=$1; ACTION=$2; RACK_ENV=$3;

# Paths
PATH=/data/$APP/current/ey_bundler_binstubs:$PATH
CURDIR=`pwd`

APP_DIR="/data/${APP}"
APP_ROOT="${APP_DIR}/current"
APP_SHARED="${APP_DIR}/shared"
APP_CONFIG="${APP_SHARED}/config"

clean_exit() {
  cd $CURDIR
  exit $RESULT
}

WORKER_REF="resque_scheduler"
LOG_FILE="/data/$APP/current/log/$WORKER_REF.log"
LOCK_FILE="/tmp/$WORKER_REF.monit-lock"
PID_FILE="/var/run/engineyard/resque-scheduler/$APP/$WORKER_REF.pid"
GEMFILE="$APP_ROOT/Gemfile"
RAKE="rake"

if [ -f $GEMFILE ];then
  RAKE="$APP_ROOT/ey_bundler_binstubs/rake"
fi

if [ -d $APP_ROOT ]; then
  USER=$(stat -L -c"%U" $APP_ROOT)
  export HOME="/home/$USER" 

  # Fix for SD-3786 - stop sending in VERBOSE= and VVERBOSE= by default
  if declare -p VERBOSE >/dev/null 2>&1; then export V="VERBOSE=$VERBOSE"; fi
  if declare -p VVERBOSE >/dev/null 2>&1; then export VV="VVERBOSE=$VVERBOSE"; fi

  # Older versions of sudo need us to call env for the env vars to be set correctly
  COMMAND="/usr/bin/env $V $VV APP_ROOT=${APP_ROOT} RACK_ENV=${RACK_ENV} RAILS_ENV=${RACK_ENV} MERB_ENV=${RACK_ENV} $RAKE -f ${APP_ROOT}/Rakefile resque:scheduler"

  if [ ! -d /var/run/engineyard/resque-scheduler/$APP ]; then
    mkdir -p /var/run/engineyard/resque-scheduler/$APP
  fi

  # handle the second param, don't start if already existing
  if [ -f $LOCK_FILE ]; then
    logger -t "monit-resquescheduler[$$]:" "Monit already messing with $WORKER_REF (`cat $LOCK_FILE`)"
    clean_exit 1
  else 
    echo $$ > $LOCK_FILE
  fi

  case "$ACTION" in
    start)
      cd /data/$APP/current
      logger -t "monit-resquescheduler[$$]:" "Starting Resque worker $WORKER_REF"
      if [ -f $PID_FILE ]; then
        PID=`cat $PID_FILE`
        if [ -d /proc/$PID ]; then
          logger -t "monit-resquescheduler[$$]:" "Resque worker $WORKER_REF is already running with $PID."
          RESULT=1
        else
          rm -f $PID_FILE
          logger -t "monit-resquescheduler[$$]:" "Removing stale worker file ($PID_FILE) for pid $PID"
        fi
      fi
      if [ ! -f $PID_FILE ]; then
        exec su -c"$COMMAND" $USER >> $LOG_FILE 2>&1 &
        RESULT=$?
        logger -t "monit-resquescheduler[$$]:" "Started with pid $! and exit $RESULT"
        #while [ ! -f $PID_FILE ]
        #do 
          echo $! > $PID_FILE
          sleep .1
        #done
      else
        RESULT=1
      fi
      rm $LOCK_FILE
      clean_exit $RESULT
      ;;
    stop)
      logger -t "monit-resquescheduler[$$]:" "Stopping Resque worker $WORKER_REF"
      if [ -f $PID_FILE ]; then
        kill -TERM `cat $PID_FILE` && sleep 30
          SLEEP_COUNT=0
          while [ -e /proc/$child ]; do
            sleep 15
            let "SLEEP_COUNT+=15"
            if(( "$SLEEP_COUNT" > 30 )); then
              kill -9 `cat $PID_FILE` 2>/dev/null; true
              logger -t "monit-resquescheduler[$$]:" "Murdering Resque worker with $PID for $WORKER_REF"
              break
            fi
          done
      fi
      [ -e "$PID_FILE" -a ! -d /proc/$PID ] && rm -f $PID_FILE
      rm $LOCK_FILE
      clean_exit 0
      ;;
    *)
      usage
      rm $LOCK_FILE
      ;;
    esac
else
  echo "/data/$APP/current doesn't exist."
  usage
fi
