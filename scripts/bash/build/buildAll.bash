#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by SDRausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SETRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 201
	exit 201
}

_SETRPEXIT_() { # Run on exi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SETRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 211
 	exit 211 
}

_SETRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 221
 	exit 221 
}

trap '_SETRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SETRPEXIT_ EXIT
trap _SETRPSIGNAL_ HUP INT TERM 
trap _SETRPQUIT_ QUIT 

export NUM="$(date +%s)"
RDR="$HOME/buildAPKs"
cd "$RDR"
. "$RDR"/scripts/bash/shlibs/lock.bash wake.start
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
. "$RDR"/scripts/bash/init/ushlibs.bash
. "$RDR"/scripts/bash/init/rshlibs.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/init/pull.buildAPKs.modules.bash
. "$RDR"/scripts/bash/build/build.in.dir.bash
. "$RDR"/scripts/bash/shlibs/lock.bash wake.stop
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
_WAKEUNLOCK_
# buildAll.bash EOF
