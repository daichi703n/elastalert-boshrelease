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

blob_download python3.12 https://www.python.org/ftp/python/3.12.8/Python-3.12.8.tgz Python-3.12.8.tgz
blob_download libffi https://buildpacks.cloudfoundry.org/dependencies/manual-binaries/python/libffi-3.2.1-linux-x64-5f5bf32c.tgz libffi-3.2.1.tgz
blob_download rust https://static.rust-lang.org/dist/rust-1.83.0-x86_64-unknown-linux-gnu.tar.xz rust-1.83.0-x86_64-unknown-linux-gnu.tar.xz

pip download -d elastalert --no-binary :all: "elastalert2==2.20.0"
pip download -d elastalert --no-binary :all: "setuptools>=40.8.0" "setuptools_scm<8.0,>=6.4" "flit_core>=3.3" "hatchling" "calver" "hatch-vcs" "hatch-fancy-pypi-readme" "wheel" "Cython" "poetry-core" "maturin<2.0,>=1.2" "setuptools-rust>=1.4.0" "mypy<=1.14.0,>=1.4.1" "types-psutil" "types-setuptools" "expandvars"
rm -f elastalert/pillow-*.tar.gz
pip wheel -w elastalert pillow
for f in $(ls elastalert/*.tar.gz elastalert/*.whl);do
  if [ ! -f ${DIR}/blobs/${f} ];then
    bosh add-blob --dir=${DIR} ${f} ${f}
  fi
done

# export BOSH_INSTALL_TARGET=bosh
