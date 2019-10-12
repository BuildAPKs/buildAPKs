#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by SDRausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SBDBTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	set +Eeuo pipefail 
	exit 201
}

_SBDBTRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SBDBTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
 	exit 211 
}

_SBDBTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SBDBTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SBDBTRPEXIT_ EXIT
trap _SBDBTRPSIGNAL_ HUP INT TERM 
trap _SBDBTRPQUIT_ QUIT 

export DAY="$(date +%Y%m%d)"
export JAD=""
export JID="in.dir.${PWD##*/}"
export NUM="$(date +%s)"
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/shlibs/lock.bash
if [[ "$HOME" = "$PWD" ]] 
then
	printf "\\n\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Cannot run in %s!  Signal 224 generated by %s in %s.\\e[0m\\n\\n" "${0##*/}" "$HOME" "${0##*/}" "$PWD"
	exit 224
fi
JDR="$PWD"
. "$RDR"/scripts/bash/shlibs/buildAPKs/fandm.bash 
_ANDB_ "$JDR"
# build.in.dir.bash EOF
