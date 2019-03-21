#!/bin/bash
set -e
<%
  elasticsearch_host = nil
  if_link("elasticsearch") { |elasticsearch_link|
    elasticsearch_host = elasticsearch_link.instances[0].address
  }
  unless elasticsearch_host
    elasticsearch_host = p("elastalert.es_host")
  end
%>
curl -s -XPOST http://<%= elasticsearch_host %>:<%= link("elastalert").p("elastalert.es_port") %>/elastalert_status_silence/silence/_delete_by_query -H 'Content-Type:application/json' -d'
{
  "query": {
    "regexp": {
       "rule_name": ".*._silence"
    }
  }
}'
