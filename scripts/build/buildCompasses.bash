#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SCOTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 201
	exit 201
}

_SCOTRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SCOTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 211
 	exit 211 
}

_SCOTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 221
 	exit 221 
}

trap '_SCOTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SCOTRPEXIT_ EXIT
trap _SCOTRPSIGNAL_ HUP INT TERM 
trap _SCOTRPQUIT_ QUIT 

export JID=compasses # job id/name
export JAD=github.com/BuildAPKs/buildAPKsCompasses
. "$HOME/buildAPKs/scripts/init.bash"

#EOF
