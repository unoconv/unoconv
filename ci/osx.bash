#!/bin/bash

set -o errexit

[[ $(uname) != 'Darwin' ]] && exit

pushd /tmp

urldir=https://downloadarchive.documentfoundation.org/libreoffice/old/$VERSION/mac/x86_64
filename=LibreOffice_${VERSION}_MacOS_x86-64.dmg

wget $urldir/$filename
sudo hdiutil attach $filename

# debug travis:
ls -l /Volumes/LibreOffice/LibreOffice.app/Contents/Resources/

PYTHON=/Volumes/LibreOffice/LibreOffice.app/Contents/MacOS/python
if [ ! -f $PYTHON ]; then
    # LibreOffice 5.2 has the python executable here instead:
    PYTHON=/Volumes/LibreOffice/LibreOffice.app/Contents/Resources/python
fi

ln -sfv $PYTHON /tmp/python
