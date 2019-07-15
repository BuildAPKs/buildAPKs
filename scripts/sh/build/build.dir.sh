#!/system/bin/env sh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Contributeur HemanthJabalpuri @sdrausty/buildAPKs/issues/13
# Invocation : $HOME/buildAPKs/scripts/sh/build/build.dir.sh sources/
#####################################################################
set -e

for APP in $(find $1 -name "AndroidManifest.xml") 
do 
	$HOME/buildAPKs/scripts/sh/build/build.sh ${APP%/*} 
done

#EOF
