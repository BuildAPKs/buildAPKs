#!/bin/env zsh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Contributeur : https://github.com/HemanthJabalpuri
# Invocation : $HOME/buildAPKs/scripts/zsh/build/build.dir.zsh dir 
#####################################################################
set -e

for APP in $(find $1 -name "AndroidManifest.xml") 
do 
	$HOME/buildAPKs/scripts/zsh/build/build.zsh ${APP%/*} 
done

#EOF
