#!/bin/env sh
# Copyright 2019 (c) all rights reserved by S D Rausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
#####################################################################
set -eu
IVIDV=$(cat ./conf/VERSIONID)
PVIDV=$(echo $IVIDV | cut -d. -f1-2)
SVIDV=$(echo $IVIDV | cut -d. -f3)
NSVIDV=$((SVIDV + 1))
echo $PVIDV.$NSVIDV > ./conf/VERSIONID 
cat ./conf/VERSIONID 
# vgen.sh EOF
