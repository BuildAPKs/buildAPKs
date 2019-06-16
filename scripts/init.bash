#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SINITRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs init.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${3:-VALUE}" "${1:-LINENO}" "${2:-BASH_COMMAND}"
	exit 179
}

_SINITRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SINITRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 178 
}

_SINITRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 177 
}

trap '_SINITRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SINITRPEXIT_ EXIT
trap _SINITRPSIGNAL_ HUP INT TERM 
trap _SINITRPQUIT_ QUIT 
export RDR="$(cat $HOME/buildAPKs/var/conf/RDR)"   #  Set variable to contents of file.
if [[ -z "${JID:-}" ]] 
then
	. "$RDR/scripts/build/buildEntertainment.bash"
	exit 0
fi
export DAY="$(date +%Y%m%d)"
export JIDL="${JID,,}"	# search.string: bash variable lower case site:tldp.org
export NUM="$(date +%s)"
export SRDR="${RDR:33}" # search.string: string manipulation site:www.tldp.org
export JDR="$RDR/sources/$JIDL"
cd "$RDR"
if [[ -f .gitmodules ]]
then
	if grep shlibs .gitmodules 1>/dev/null
	then
		(git pull && git submodule update --init --recursive --remote scripts/shlibs) || (printf "\\nCANNOT UPDATE ~/buildAPKs/scripts/shlibs: Continuing...\\n") 
	else
	       	(git pull && git submodule add https://github.com/shlibs/shlibs scripts/shlibs) || (printf "\\nCANNOT ADD MODULE: Continuing...\\n")
	fi
else
	       	(git pull && git submodule add https://github.com/shlibs/shlibs scripts/shlibs) || (printf "\\nCANNOT ADD MODULE: Continuing...\\n")
fi

. "$RDR/scripts/shlibs/mod.bash"

#EOF
