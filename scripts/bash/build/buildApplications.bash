#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/init/atrap.bash" 67 68 69 "${0##*/} buildApplications.bash"
export JAD=github.com/BuildAPKs/buildAPKsApps
export JID=applications	# job id/name
. "$HOME/buildAPKs/scripts/bash/init/init.bash" "$@"
# buildApplications.bash EOF
