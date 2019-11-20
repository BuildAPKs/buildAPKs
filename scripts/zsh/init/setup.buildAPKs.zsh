#!/bin/env zsh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Invocation : ~/buildAPKs/scripts/zsh/init/setup.BuildAPKs.zsh  
#####################################################################
set -e
STRING1="Command \`au\` enables rollback; Available at https://wae.github.io/au/: Continuing..."
STRING2="Cannot update ~/buildAPKs prerequisites: Continuing..."
STRING3="Cannot clone ~/buildAPKs: Continuing..."
printf "\\e[1;38;5;117m%s\\e[0m\\n" "Beginning buildAPKs setup:"
[ ! -z "$(command -v "au")" ] && (au aapt apksigner curl dx ecj git) || (printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING1") || [ ! -z "$(command -v pkg)" ] && (pkg install aapt apksigner curl dx ecj git) || (printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2") 
cd "$HOME"
git clone https://github.com/BuildAPKs/buildAPKs || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING3"
bash "$HOME"/buildAPKs/scripts/bash/build/build.entertainment.bash
# setup.BuildAPKs.zsh EOF
