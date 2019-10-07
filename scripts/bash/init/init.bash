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
	. "$RDR"/scripts/bash/build/build.entertainment.bash
	exit 0
fi
cd "$RDR"
if [[ ! -f scripts/bash/shlibs/.git ]] 
then
	(git pull) || (printf "\\nCANNOT UPDATE ~/%s: Continuing...\\n\\n" "${RDR##*/}")
fi
if [[ ! -f .gitmodules ]] 
then
	touch .gitmodules
fi
if grep shlibs .gitmodules 1>/dev/null
then
	(git submodule update --init --recursive --remote scripts/bash/shlibs) || (printf "\\nCANNOT UPDATE ~/%s/scripts/bash/shlibs: Continuing...\\n\\n" "${RDR##*/}") 
else
	(git submodule add https://github.com/shlibs/shlibs.bash scripts/bash/shlibs && git submodule update --init --recursive --remote scripts/bash/shlibs) || (printf "\\nCANNOT ADD AND UPDATE MODULE ~/%s/scripts/bash/shlibs: Continuing...\\n\\n" "${RDR##*/}")
fi
if [[ ! -d "scripts/bash/shlibs" ]] 
then
	(git clone https://github.com/shlibs/shlibs.bash scripts/bash/shlibs && git clone https://github.com/shlibs/shlibs.buildAPKs.bash scripts/bash/shlibs/buildAPKs) || (printf "\\nCANNOT CLONE MODULES %s AND %s INTO~/%s/scripts/bash/shlibs AND ~/%s/scripts/bash/shlibs/buildAPKs: Continuing...\\n\\n" "https://github.com/shlibs/shlibs.bash" "https://github.com/shlibs/shlibs.buildAPKs.bash" "${RDR##*/}" "${RDR##*/}")
fi
. "$RDR"/scripts/bash/init/prep.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/mod.bash
# init.bash EOF
