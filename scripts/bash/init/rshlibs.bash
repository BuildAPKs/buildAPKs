#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SRSTRPERROR_() { # run on script error
	local RV="$?"
	echo "$RV" init.bash
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 147
}

_SRSTRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SRSTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 148 
}

_SRSTRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 149 
}

trap '_SRSTRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SRSTRPEXIT_ EXIT
trap _SRSTRPSIGNAL_ HUP INT TERM 
trap _SRSTRPQUIT_ QUIT 

_IFSHLIBS_() { 
	if [[ ! -d "$RDR"/scripts/bash/shlibs ]] 
	then
		git clone https://github.com/shlibs/shlibs.bash scripts/bash/shlibs && git clone https://github.com/shlibs/shlibs.buildAPKs.bash scripts/bash/shlibs/buildAPKs || printf "\\nCannot clone modules %s and %s into~/%s/scripts/bash/shlibs and ~/%s/scripts/bash/shlibs/buildAPKs: Continuing...\\n\\n" "https://github.com/shlibs/shlibs.bash" "https://github.com/shlibs/shlibs.buildAPKs.bash" "${RDR##*/}" "${RDR##*/}"
	fi
}

export RDR="$HOME/buildAPKs"   
cd "$RDR"
if [[ ! -f "$RDR"/scripts/bash/shlibs/.git ]] 
then
	git pull || printf "\\nCannot update ~/%s: Continuing...\\n\\n" "${RDR##*/}"
fi
_IFSHLIBS_
# rshlibs.bash EOF
