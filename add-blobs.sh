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

blob_download python3.13 https://www.python.org/ftp/python/3.13.1/Python-3.13.1.tgz Python-3.13.1.tgz
#blob_download python3.13 https://sh.rustup.rs rustup-init.sh
blob_download libffi https://buildpacks.cloudfoundry.org/dependencies/manual-binaries/python/libffi-3.2.1-linux-x64-5f5bf32c.tgz libffi-3.2.1.tgz

pip download -d elastalert --no-binary :all: elastalert2==2.22.0
pip download -d elastalert --no-binary :all: "setuptools>=40.8.0" "setuptools_scm<8.0,>=6.4" "flit_core>=3.3" "Cython>=3.0" "maturin<2.0,>=1.2" "setuptools-rust>=1.4.0" "mypy<=1.14.0,>=1.4.1"
pip download -d elastalert --no-binary :all: calver hatchling hatch-vcs hatch-fancy-pypi-readme wheel poetry-core types-psutil types-setuptools expandvars
for f in $(ls elastalert/*.tar.gz);do 
  bosh add-blob --dir=${DIR} ${f} ${f}
done

# export BOSH_INSTALL_TARGET=bosh
