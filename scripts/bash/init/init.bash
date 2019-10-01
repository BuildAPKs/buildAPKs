#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SINITRPERROR_() { # run on script error
	local RV="$?"
	echo "$RV" init.bash
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 147
}

_SINITRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SINITRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 148 
}

_SINITRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 149 
}

trap '_SINITRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SINITRPEXIT_ EXIT
trap _SINITRPSIGNAL_ HUP INT TERM 
trap _SINITRPQUIT_ QUIT 

export RDR="$HOME/buildAPKs"   
if [[ -z "${JID:-}" ]] 
then
	. "$RDR/scripts/bash/build/build.entertainment.bash"
	exit 0
fi
if [[ ! -d "$RDR"/cache/tarballs ]]
then
	mkdir -p "$RDR"/cache/tarballs
fi
export DAY="$(date +%Y%m%d)"
export NUM="$(date +%s)"
export SRDR="${RDR##*/}" # search: string manipulation site:www.tldp.org
export JDR="$RDR/sources/$JID"
cd "$RDR"
(git pull) || (printf "\\nCANNOT UPDATE ~/%s: Continuing...\\n\\n" "${RDR##*/}") 
if [[ ! -d "scripts/bash/shlibs" ]] 
then
	(git clone https://github.com/shlibs/shlibs.bash scripts/bash/shlibs) || (printf "\\nCANNOT CLONE MODULE: Continuing...\\n\\n")
else
	if grep shlibs .gitmodules 1>/dev/null
	then
		(git submodule update --init --recursive --remote scripts/bash/shlibs) || (printf "\\nCANNOT UPDATE ~/%s/scripts/bash/shlibs: Continuing...\\n\\n" "${RDR##*/}") 
	else
		(git submodule add https://github.com/shlibs/shlibs.bash scripts/bash/shlibs) || (printf "\\nCANNOT ADD MODULE: Continuing...\\n\\n")
	fi
fi

. "$RDR/scripts/bash/init/prep.bash"
. "$RDR/scripts/bash/shlibs/mod.bash"

# init.bash EOF
