#!/usr/bin/env ksh
# Copyright 2021 (c) all rights reserved
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# See LICENSE for details https://buildapks.github.io/docsBuildAPKs/
#####################################################################
set -e
for APP in $(find $1 -name "AndroidManifest.xml")
do
	$HOME/buildAPKs/scripts/ksh/build/build.ksh ${APP%/*}
done
# build.dir.ksh EOF
