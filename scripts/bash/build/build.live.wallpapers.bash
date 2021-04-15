#!/usr/bin/env bash
# Copyright 2019-2021 (c) all rights reserved
# by BuildAPKs https://buildapks.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/init/atrap.bash" 67 68 69 "${0##*/} build.live.wallpapers.bash"
export JAD=github.com/BuildAPKs/buildAPKs.live.wallpapers
export JID=live.wallpapers # job id/name
. "$HOME/buildAPKs/scripts/bash/init/init.bash" "$@"
# build.live.wallpapers.bash EOF
