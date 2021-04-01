#!/usr/bin/env bash
# Copyright 2021 (c) all rights reserved by BuildAPKs; see LICENSE
# https://buildapks.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/init/atrap.bash" 67 68 69 "${0##*/} build.keyboards.bash"
export JAD="github.com/BuildAPKs/buildAPKs.keyboards"
export JID="keyboards"	# job id/name
. "$HOME/buildAPKs/scripts/bash/init/init.bash" "$@"
# build.keyboards.bash EOF
