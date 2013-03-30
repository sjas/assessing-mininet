#!/bin/bash
#
# FOR THIS TO WORK, PLACE PATCH FILES IN ~/D-ITG-PATCH
#
# goto home folder
cd /home/root
# create working dir
mkdir D-ITG
cd D-ITG
# get itg source for linux
wget http://traffic.comics.unina.it/software/ITG/codice/D-ITG-2.8.0-rc1.tgz
# untar
tar xf D-ITG-2.8.0-rc1.tgz
# cd
cd D-ITG-2.8.0-rc1
# next lines won't work since patch cannot be aplied anymore!
# patch was for another revision of the version control and is out of sync now.
#cp ~/D-ITG-PATCH/* .
#patch -p1 --dry-run < ITGDec.patch
#cd src
#make
echo
echo 'apply patch by hand now!'
echo 'it is around line 545, not 535 or so.'
echo 'then cd src/ and make...'
