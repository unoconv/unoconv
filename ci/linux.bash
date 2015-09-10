#!/bin/bash

set -o errexit

[[ $(uname) != 'Linux' ]] && exit

pushd /tmp

if [[ "$VERSION" =~ ^3.3.* ]]; then
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/deb/x86_64
    cutversion=$(echo $VERSION | sed 's/\.[0-9]$//')
    filename=LibO_${cutversion}_Linux_x86-64_install-deb_en-US
elif [[ "$VERSION" =~ ^3.[4-5].* ]]; then
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/deb/x86_64
    rcversion=$(echo $VERSION | sed 's/\.2$/rc2/')
    filename=LibO_${rcversion}_Linux_x86-64_install-deb_en-US
elif [[ "$VERSION" =~ ^3.* ]]; then
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/deb/x86_64
    filename=LibO_${VERSION}_Linux_x86-64_install-deb_en-US
elif [[ "$VERSION" =~ ^4.[0-3].* ]]; then
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/deb/x86_64
    filename=LibreOffice_${VERSION}_Linux_x86-64_deb
else
    urldir=http://download.documentfoundation.org/libreoffice/stable/$VERSION/deb/x86_64/
    filename=LibreOffice_${VERSION}_Linux_x86-64_deb
fi

wget $urldir/${filename}.tar.gz
tar xvf ${filename}.tar.gz
dpkg -i Lib*_Linux_x86-64*deb*/DEBS/*.deb

twodigitsversion=$(echo $VERSION | cut -c 1-3)
ln -s /opt/libreoffice${twodigitsversion}/program/python /tmp/python
