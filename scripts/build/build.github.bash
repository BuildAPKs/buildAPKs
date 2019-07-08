#!/bin/env bash
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SGTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	exit 201
}

_SGTRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SGTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 211 
}

_SGTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SGTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SGTRPEXIT_ EXIT
trap _SGTRPSIGNAL_ HUP INT TERM 
trap _SGTRPQUIT_ QUIT 

if [[ -z "${1:-}" ]] 
then
	printf "\\n%s\\n" "GitHub username must be provided!"
	exit 227
fi
export USER="$1"
export DAY="$(date +%Y%m%d)"
export JAD=""
export JID="git.$USER"
export NUM="$(date +%s)"
export RDR="$HOME/buildAPKs"
export JDR="$RDR/sources/github/$USER"
. "$HOME/buildAPKs/scripts/shlibs/lock.bash"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
cd "$JDR"
if [[ -f "repos" ]] 
then
	:
else
	curl -O https://api.github.com/users/$USER/repos 
fi
ARR=($(grep -B 5 Java repos |grep svn_url|awk -v x=2 '{print $x}'|sed 's/\,//g'|sed 's/\"//g'|xargs))
for i in "${ARR[@]}"
do
if [[ ! -f " ${i##*/}.tar.gz" ]] 
then
	printf "\\n%s\\n" "Getting $i/tarball/master -o ${i##*/}.tar.gz:"
	curl -L "$i"/tarball/master -o "${i##*/}.tar.gz" ||:
fi
tar xvf "${i##*/}.tar.gz" ||:
done
find "$JDR" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/build/build.one.bash" "$JID" "$JDR" {} \; 2>> "$HOME/buildAPKs/log/stnderr."$JID".log" ||:

#EOF
