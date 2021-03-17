#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved by BuildAPKs; see LICENSE
# https://buildapks.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/init/atrap.bash" 67 68 69 "${0##*/} buildBrowsers.bash"
export JAD="github.com/sdrausty/buildAPKsBrowsers"
export JID="browsers"		# job id/name
. "$HOME/buildAPKs/scripts/bash/init/init.bash" "$@"
# buildBrowsers.bash EOF
