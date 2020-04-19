#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by BuildAPKs; see LICENSE
# https://buildapks.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/shlibs/trap.bash" 67 68 69 "${0##*/} build.samples.bash"
export NUM="$(date +%s)"
export RDR="$HOME/buildAPKs"
export SDR="/scripts/bash/build"
export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')" # load login:token key from .conf/GAUTH file; This file has information about enabling OAUTH authentication.
declare -a LIST # declare array for all build scripts 
LIST=("$RDR$SDR/build.apps.bash" "$RDR$SDR/build.clocks.bash" "$RDR$SDR/build.compasses.bash" "$RDR$SDR/build.developers.tools.bash" "$RDR$SDR/build.entertainment.bash" "$RDR$SDR/build.flashlights.bash" "$RDR$SDR/build.games.bash" "$RDR$SDR/build.live.wallpapers.bash" "$RDR$SDR/build.samples.bash" "$RDR$SDR/buildApplications.bash" "$RDR$SDR/buildBrowsers.bash" "$RDR$SDR/buildFlashlights.bash" "$RDR$SDR/buildGames.bash" "$RDR$SDR/buildSamples.bash" "$RDR$SDR/buildTop10.bash" "$RDR$SDR/buildTutorials.bash" "$RDR$SDR/buildWidgets.bash") 
. "$RDR/scripts/bash/shlibs/lock.bash" wake.start 
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.st 
for NAME in "${LIST[@]}"
do
	"$NAME"
done
. "$RDR/scripts/bash/shlibs/lock.bash" wake.stop 
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.gt 
# build.buildAPKs.bash EOF
