#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by BuildAPKs 
# See LICENSE for details https://buildapks.github.io/docsBuildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SUPTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh ERROR:  Signal %s received!\\e[0m\\n" "$RV"
	printf "\\e[?25h\\e[0m\\n"
	exit 201
}

_SUPTRPEXIT_() { # Run on exit.
	local RV="$?"
	sleep 0.04
	if [[ "$RV" = 0 ]] ; then
		printf "\\a\\e[1;7;38;5;155m%s %s \\a\\e[0m\\e[1;34m: \\a\\e[1;32m%s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "DONE 🏁 "
		printf "\\e]2; %s: %s \\007" "${0##*/} $ARGS" "DONE 🏁 "
	else
		printf "\\a\\e[1;7;38;5;88m%s %s \\a\\e[0m\\e[1;34m: \\a\\e[1;32m%s %s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "[Exit Signal $RV]" "DONE 🏁 "
		printf "\033]2; %s: %s %s \\007" "${0##*/} $ARGS" "[Exit Signal $RV]" "DONE 🏁 "
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SUPTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh WARNING:  Signal %s received!\\e[0m\\n" "$RV"
 	exit 211 
}

_SUPTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh WARNING:  Quit signal %s received!\\e[0m\\n" "$RV"
 	exit 221 
}

trap '_SUPTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SUPTRPEXIT_ EXIT
trap _SUPTRPSIGNAL_ HUP INT TERM 
trap _SUPTRPQUIT_ QUIT 

_INPKGS_() {
	if [[ "$COMMANDIF" = au ]] 
	then 
		au $(echo ${PKGS[@]}) || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
	else
		pkg install $(echo ${PKGS[@]}) || printf "\\e[1;37;5;116m%s\\e[0m\\n" "$STRING2"
	fi
}

declare -a ARGS="$@"
declare COMMANDR
declare COMMANDIF
declare STRING1
declare STRING2
declare RDR
export RDR="$HOME/buildAPKs"
STRING1="COMMAND \`au\` enables rollback, available at https://wae.github.io/au/ IS NOT FOUND: Continuing... "
STRING2="Cannot update ~/${RDR##*/} prerequisite: Continuing..."
printf "\\e[1;38;5;115m%s\\e[0m\\n" "Beginning buildAPKs setup:"
COMMANDR="$(command -v au)" || (printf "%s\\n\\n" "$STRING1") 
COMMANDIF="${COMMANDR##*/}"
PKGS=(aapt apksigner curl dx ecj git)
if [[ -z "${1:-}" ]]
then
	ARGS=""
fi
for PKG in "${PKGS[@]}"
do
	COMMANDP="$(command -v $PKG)" || printf "Command not found: Continuing...\\n"
	COMMANDPF="${COMMANDP##*/}"
	if [[ "$COMMANDPF" != "$PKG" ]] 
	then 
		_INPKGS_
	fi
done
cd "$HOME"
git clone https://github.com/BuildAPKs/buildAPKs || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
bash "$RDR/scripts/bash/build/build.entertainment.bash"
# setup.buildAPKs.bash EOF
