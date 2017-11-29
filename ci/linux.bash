#!/bin/bash

set -o errexit

[[ $(uname) != 'Linux' ]] && exit

pushd /tmp

urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/deb/x86_64
filename=LibreOffice_${VERSION}_Linux_x86-64_deb

wget $urldir/${filename}.tar.gz
tar xvf ${filename}.tar.gz
dpkg -i Lib*_Linux_x86-64*deb*/DEBS/*.deb

twodigitsversion=$(echo $VERSION | cut -c 1-3)
ln -sf /opt/libreoffice${twodigitsversion}/program/python /tmp/python
