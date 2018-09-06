#!/bin/bash

RULE_DIR=/var/vcap/jobs/elastalert/bin/<%= p('elastalert.rules_folder') %>

mkdir -p ${RULE_DIR}
rm -f ${RULE_DIR}/*

<% p('elastalert.rules').each_with_index do |rule, i| %>
cat <<'EOF' > ${RULE_DIR}/rule_<%= i %>.yml
<%= YAML.dump(JSON.load(JSON.dump(rule))).gsub("---\n", '').strip %>
EOF
<% end %>
