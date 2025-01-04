#!/bin/bash
set -e

RUN_DIR=/var/vcap/sys/run/elastalert
LOG_DIR=/var/vcap/sys/log/elastalert
STORE_DIR=/var/vcap/store/elastalert
JOB_DIR=/var/vcap/jobs/elastalert
TMP_DIR=/var/vcap/sys/tmp/elastalert
PIDFILE=$RUN_DIR/elastalert.pid

export PATH=/var/vcap/packages/python3.13/bin:/var/vcap/packages/elastalert/bin:$PATH
export CONFIG_DIR=/var/vcap/jobs/elastalert/config
export PYTHONPATH=/var/vcap/packages/elastalert/lib/python3.13/site-packages/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/var/vcap/packages/python3.13/lib

source $JOB_DIR/bin/ctl_utils.sh

case $1 in

  start)
    mkdir -p $RUN_DIR $LOG_DIR $STORE_DIR $TMP_DIR

    pid_guard $PIDFILE elastalert

    elastalert-create-index --config $CONFIG_DIR/config.yml \
      >>$LOG_DIR/elastalert.stdout.log 2>>$LOG_DIR/elastalert.stderr.log

    echo "Starting elastalert..." >>$LOG_DIR/elastalert.stdout.log
    echo $$ > $PIDFILE

    exec elastalert --verbose \
      --es_debug_trace $LOG_DIR/trace.log \
      --config $CONFIG_DIR/config.yml \
      >>$LOG_DIR/elastalert.stdout.log 2>>$LOG_DIR/elastalert.stderr.log
    ;;

  stop)
    echo "Stopping elastalert..." >>$LOG_DIR/elastalert.stdout.log
    kill_and_wait $PIDFILE
    ;;

  *)
  echo "Usage: ctl {start|stop}" ;;
esac
exit 0

