#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved
# by SDRausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/init/atrap.bash" 67 68 69 "${0##*/} buildAll.bash"
export NUM="$(date +%s)"
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/shlibs/lock.bash wake.start
. "$RDR"/scripts/bash/init/ushlibs.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/init/build.buildAPKs.modules.bash
cd "$RDR"/sources/
. "$RDR"/scripts/bash/build/build.in.dir.bash
. "$RDR"/scripts/bash/shlibs/lock.bash wake.stop
# buildAll.bash EOF
