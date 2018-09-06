#!/bin/bash

DIR=`pwd`

mkdir -p .downloads

cd .downloads

blob_download() {
  set -eu
  local package=$1
  local url=$2
  local f=$3
  if [ ! -f ${DIR}/blobs/${package}/${f} ];then
    curl -L -J ${url} -o ${f}
    bosh add-blob --dir=${DIR} ${f} ${package}/${f}
  fi
}

blob_download python2.7 https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz Python-2.7.15.tgz
blob_download libffi https://buildpacks.cloudfoundry.org/dependencies/manual-binaries/python/libffi-3.2.1-linux-x64-5f5bf32c.tgz libffi-3.2.1.tgz

pip download -d elastalert --no-binary :all: elastalert==0.1.35
for f in $(ls elastalert/*.tar.gz);do 
  bosh add-blob --dir=${DIR} ${f} ${f}
done
