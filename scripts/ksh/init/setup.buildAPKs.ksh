#!/usr/bin/env ksh
# Copyright 2021 (c) all rights reserved
# by BuildAPKs https://buildapks.github.io/buildAPKs/
#####################################################################
set -e
STRING1="Command \`au\` enables rollback; Available at https://wae.github.io/au/: Continuing..."
STRING2="Cannot update ~/buildAPKs prerequisites: Continuing..."
STRING3="Cannot clone ~/buildAPKs: Continuing..."
printf "%s\\n" "Beginning buildAPKs setup:"
( ( [ -n "$(command -v "au")" ] && (au aapt apksigner curl dx ecj git) ) || (printf "%s\\n" "$STRING1") ) || ( ( [ -n "$(command -v apt)" ] && (apt install aapt apksigner curl dx ecj git) ) || (printf "%s\\n" "$STRING2") )
cd "$HOME"
git clone https://github.com/BuildAPKs/buildAPKs || printf "%s\\n\\n" "$STRING3"
bash "$HOME"/buildAPKs/scripts/bash/build/build.entertainment.bash "$@"
# setup.BuildAPKs.ksh EOF
