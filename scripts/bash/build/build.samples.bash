#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by BuildAPKs; see LICENSE
# https://buildapks.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 67 68 69 "${0##*/} build.samples.bash"
export JAD=github.com/BuildAPKs/buildAPKs.samples 
export JID="samps" # job id/name
. "$HOME/buildAPKs/scripts/bash/init/init.bash" "$@"
# build.samples.bash EOF
