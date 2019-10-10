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

RDR="$HOME/buildAPKs"
if [[ ! -f "$RDR"/scripts/bash/shlibs/.git ]]
then
	cd "$RDR/"
	(printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Adding ~/buildAPKs/scripts/bash/shlibs..." && git submodule add https://github.com/shlibs/shlibs.bash scripts/bash/shlibs && git submodule update --init --recursive --remote scripts/bash/shlibs) || (printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Updating ~/buildAPKs/scripts/bash/shlibs..." && git submodule update --init --recursive --remote scripts/bash/shlibs)
fi
"$RDR/scripts/bash/shlibs/buildAPKs/pull.buildAPKs.modules.bash"
cd "$RDR/sources/"
"$RDR/scripts/bash/build/build.in.dir.bash"
# buildAll.bash EOF
