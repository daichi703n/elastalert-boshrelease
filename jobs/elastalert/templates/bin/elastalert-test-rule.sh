#!/bin/bash
set -e

export PATH=/var/vcap/packages/python3.12/bin:/var/vcap/packages/elastalert/bin:$PATH
export CONFIG_DIR=/var/vcap/jobs/elastalert/config
export PYTHONPATH=/var/vcap/packages/elastalert/lib/python3.12/site-packages/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/var/vcap/packages/python3.12/lib

RULE_DIR=<%= p('elastalert.rules_folder') %>

for rule in `ls ${RULE_DIR}/*.yml`;do
  echo $rule
  elastalert-test-rule --config $CONFIG_DIR/config.yml $rule $@
done
