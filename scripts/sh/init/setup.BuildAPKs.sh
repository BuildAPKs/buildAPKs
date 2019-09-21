#!/bin/env sh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Invocation: ~/buildAPKs/scripts/sh/init/setup.BuildAPKs.sh 
#####################################################################

STRINGA="Cannot update ~/buildAPKs prerequisites: Continuing..."
STRINGB="Command \`au\` enables rollback; Available at https://github.com/sdrausty/au : Continuing..."
printf "%s\\n" "Beginning buildAPKs setup:"
for CMD in au pkg
do
       	[ ! -z "$(command -v "$CMD")" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "\\e[1;38;5;117m%s\\n" "$STRINGB") 
done
cd "$HOME"
(git clone https://github.com/BuildAPKs/buildAPKs) || (printf "%s\\n\\n" "$STRINGA") 
bash "$HOME/buildAPKs/scripts/bash/build/build.entertainment.bash"

# setup.BuildAPKs.sh EOF
