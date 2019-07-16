#!/bin/env zsh 
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# Contributeur : https://github.com/SDRausty
# Invocation : $HOME/buildAPKs/scripts/zsh/init/setup.BuildAPKs.zsh sources/
#####################################################################
set -e

STRING0="Command \`au\` enables rollback; Available at https://github.com/sdrausty/au : Continuing..."
STRING1="Cannot update ~/buildAPKs prerequisites : Continuing..."
printf "%s\\n" "Beginning buildAPKs setup:"
[ ! -z "$(command -v "au")" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "%s\\n" "$STRING0") 
[ ! -z "$(command -v "pkg")" ] && ("$CMD" aapt apksigner curl dx ecj findutils git) || (printf "%s\\n" "$STRING1") 
cd "$HOME"
(git clone https://github.com/BuildAPKs/buildAPKs) || (printf "%s\\n\\n" "$STRING1") 
(git clone https://github.com/BuildAPKs/buildAPKs.entertainment) || (printf "%s\\n\\n" "$STRING1") 
"$HOME/buildAPKs/scripts/zsh/build/build.dir.zsh" "$HOME/buildAPKs/sources/entertainment"

#EOF
