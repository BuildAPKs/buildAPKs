#!/bin/env sh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Contributeur : https://github.com/SDRausty
# Invocation : $HOME/buildAPKs/scripts/sh/init/setup.sh sources/
#####################################################################
set -e

STRING="Command \`au\` enables rollback; Available at https://github.com/sdrausty/au : Continuing..."
STRING2="Cannot update ~/buildAPKs prerequisites : Continuing..."
printf "%s\\n" "Beginning buildAPKs setup:"
[ ! -z "$(command -v "au")" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "%s\\n" "$STRING") 
[ ! -z "$(command -v "pkg")" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "%s\\n" "$STRING2") 
cd "$HOME"
(git clone https://github.com/BuildAPKs/buildAPKs) || (printf "%s\\n\\n" "$STRING2") 
(git clone https://github.com/BuildAPKs/buildAPKs.entertainment) || (printf "%s\\n\\n" "$STRING2") 
"$HOME/buildAPKs/scripts/sh/build/build.dir.sh" "$HOME/buildAPKs/sources/entertainment"

#EOF
