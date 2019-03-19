#!/bin/bash
set -e
RUN_DIR=/var/vcap/sys/run/elastalert
LOG_DIR=/var/vcap/sys/log/elastalert
STORE_DIR=/var/vcap/store/elastalert
JOB_DIR=/var/vcap/jobs/elastalert
TMP_DIR=/var/vcap/sys/tmp/elastalert
PIDFILE=$RUN_DIR/elastalert.pid
RULE_DIR=<%= link("elastalert").p("elastalert.rules_folder") %>

export PATH=/var/vcap/packages/python2.7/bin:/var/vcap/packages/elastalert/bin:$PATH
export CONFIG_DIR=/var/vcap/jobs/elastalert/config
export PYTHONPATH=/var/vcap/packages/elastalert/lib/python2.7/site-packages/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/var/vcap/packages/python2.7/lib

source $JOB_DIR/bin/ctl_utils.sh

<% link("elastalert").p("elastalert.rules").each_with_index do |rule, i| %>
elastalert --verbose --config $CONFIG_DIR/config.yml --rule $RULE_DIR/rule_<%= i %>.yml --silence days=7
<% end %>
