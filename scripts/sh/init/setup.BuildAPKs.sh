#!/bin/env sh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Contributeur : https://github.com/SDRausty
# Invocation : $HOME/buildAPKs/scripts/sh/init/setup.sh sources/
#####################################################################
set -e

STRING="Cannot update ~/buildAPKs prerequisites: Continuing..."
printf "\\e[1;38;5;116m%s\\n\\e[0m" "Beginning buildAPKs setup:"

for CMD in au pkg
# COMMAND `au` enables rollback, available at https://github.com/sdrausty/au 
do
       	[ ! -z "$(command -v "$CMD")" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "\\e[1;38;5;117m%s\\n" "$STRING2") 
done
cd "$HOME"
(git clone https://github.com/BuildAPKs/buildAPKs) || (printf "%s\\n\\n" "$STRING") 
"$HOME/buildAPKs/scripts/bash/build/build.entertainment.bash"

#EOF
