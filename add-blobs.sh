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
pip download -d elastalert --no-binary :all: python-magic
pip download -d elastalert --no-binary :all: future
curl -L -J https://files.pythonhosted.org/packages/ab/10/817237669677f568238bb26760fe373b3b0be200cac309e0035389beff9a/thehive4py-1.6.0-py2-none-any.whl -o elastalert/thehive4py-1.6.0-py2-none-any.whl
rm -f elastalert/elastalert-*.tar.gz
curl -L -J https://files.pythonhosted.org/packages/59/47/d5c3c0b687c9e4c81b75eacee1b3cd29f0a101c92ebebd4a41464b61c622/elastalert-0.2.0b2.tar.gz -o elastalert/elastalert-0.2.0b2.tar.gz
for f in $(ls elastalert/*.tar.gz elastalert/*.whl);do 
  bosh add-blob --dir=${DIR} ${f} ${f}
done

# export BOSH_INSTALL_TARGET=bosh
