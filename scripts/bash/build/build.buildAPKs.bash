#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by BuildAPKs; see LICENSE
# https://buildapks.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/shlibs/trap.bash" 67 68 69 "${0##*/} build.buildAPKs.bash"
export NUM="$(date +%s)"
export RDR="$HOME/buildAPKs"
export SDR="/scripts/bash/build"
export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')" # load login:token key from file .conf/GAUTH which has information about enabling OAUTH authentication.
declare -a LIST # declare array for all build scripts 
LIST=("$(find ~/buildAPKs/scripts/bash/build/ -type f -name "*.bash")")
cd "$RDR"
. "$RDR/scripts/bash/shlibs/lock.bash" wake.start 
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.st 
. "$RDR/scripts/bash/shlibs/buildAPKs/init/build.buildAPKs.modules.bash"
for NAME in "${LIST[@]}"
do
	"$NAME"
done
. "$RDR/scripts/bash/shlibs/lock.bash" wake.stop 
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.gt 
# build.buildAPKs.bash EOF
