#!/bin/sh
fly -t home sp -p elastalert-boshrelease \
    -c `dirname $0`/pipeline.yml \
    -l `dirname $0`/credentials.yml