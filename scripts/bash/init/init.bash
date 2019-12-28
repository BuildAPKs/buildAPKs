#!/usr/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"   
. "$RDR"/scripts/bash/init/atrap.bash 147 148 149 "${0##*/} init.bash" 
cd "$RDR"
[ -z "${JID:-}" ] && "$RDR"/scripts/bash/build/build.entertainment.bash && exit 0
[ ! -f "$RDR"/.gitmodules ] && touch "$RDR"/.gitmodules
. "$RDR"/scripts/bash/init/ushlibs.bash 
. "$RDR"/scripts/bash/shlibs/buildAPKs/prep.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/init/mod.bash "$@"
# init.bash EOF
