#!/bin/env zsh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Invocation : ~/buildAPKs/scripts/zsh/init/setup.BuildAPKs.zsh  
#####################################################################
set -e

STRING1="Command \`au\` enables rollback; Available at https://wae.github.io/au/ : Continuing..."
STRING2="Cannot update ~/buildAPKs prerequisites : Continuing..."
printf "%s\\n" "Beginning buildAPKs setup:"
[ -z "$(command -v au)" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "%s\\n" "$STRING1") 
[ -z "$(command -v pkg)" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "%s\\n" "$STRING2") 
cd "$HOME"
(git clone https://github.com/BuildAPKs/buildAPKs) || (printf "%s\\n\\n" "$STRING2") 
bash "$HOME/buildAPKs/scripts/bash/build/build.entertainment.bash"

# setup.BuildAPKs.zsh EOF
