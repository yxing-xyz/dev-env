#!/bin/bash

[ $(id -u) != "0" ] && { echo "You must be root to run this script"; exit 1; }

script_dir=$(dirname "`readlink -f $0`")

cd ${script_dir}
cd ..
cd slock

git checkout .

patch <  ../slock-patches/slock-dpms-1.4.diff

sed -i 's|static const char \*group = "nogroup";|static const char *group = "nobody";|' config.def.h

make

make install




		  
