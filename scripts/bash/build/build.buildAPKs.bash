#!/usr/bin/env bash
# Copyright 2019-2021 (c) all rights reserved by BuildAPKs; see LICENSE
# https://buildapks.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
declare -a LIST # declare array for build scripts
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/init/atrap.bash" 67 68 69 "${0##*/} build.buildAPKs.bash"
export NUM="$(date +%s)"
export RDR="$HOME/buildAPKs"
export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')" # load login:token key from file.  File RDR/.conf/GAUTH has more information about enabling OAUTH authentication.
. "$RDR/scripts/bash/shlibs/lock.bash" wake.start
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.st
. "$RDR/scripts/bash/shlibs/buildAPKs/init/build.buildAPKs.modules.bash"
LIST=($(find "$RDR/scripts/bash/build/" -type f -name "*.bash" -not -name "build.buildAPKs.bash" -not -name "build.in.dir.bash" -not -name "build.one.bash" -not -name "buildAll.bash"))
for NAME in "${LIST[@]}"
do
	"$NAME"
done
. "$RDR/scripts/bash/shlibs/lock.bash" wake.stop
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.gt
# build.buildAPKs.bash EOF
