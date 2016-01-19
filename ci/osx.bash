#!/bin/bash

set -o errexit

[[ $(uname) != 'Darwin' ]] && exit

pushd /tmp

if [[ "$VERSION" =~ ^3.6.* ]]; then
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/mac/x86
    filename=LibO_${VERSION}_MacOS_x86_install_en-US.dmg
elif [[ "$VERSION" =~ ^4.[0-1].* ]]; then
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/mac/x86
    filename=LibreOffice_${VERSION}_MacOS_x86.dmg
else
    urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/mac/x86_64
    filename=LibreOffice_${VERSION}_MacOS_x86-64.dmg
else
fi

wget $urldir/$filename
sudo hdiutil attach $filename

ln -s /Volumes/LibreOffice/LibreOffice.app/Contents/MacOS/python /tmp/python
