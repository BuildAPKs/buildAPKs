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

export RDR="$HOME/buildAPKs"
if [[ -z "${1:-}" ]] 
then
	printf "\\e[1;7;38;5;202m\\n\\n%s\\n\\e[0m\\n" "GitHub topic must be provided;  See \`~/${RDR##*/}/conf/TNAMES\` for topics that build APKs on device with BuildAPKs!  To build all the topic names contained in this file run \`for i in \$(cat ~/${RDR##*/}/conf/TNAMES) ; do ~/${RDR##*/}/scripts/bash/build/build.github.topic.bash \$i ; done\`.  File \`~/${RDR##*/}/conf/OAUTH\` has important information should you choose to run this command regarding bandwidth supplied by GitHub. "
	exit 227
fi
export TOPI="${1%/}"
export TOPIC="${TOPI##*/}"
export TOPNAME="${TOPIC,,}"
export JDR="$RDR/sources/github/$TOPIC"
export JID="git.$TOPIC"
export OAUT="$(cat "$RDR/conf/OAUTH" | awk 'NR==1')"
export STRING="ERROR FOUND; build.github.bash $1:  CONTINUING... "
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "Beginning BuildAPKs with build.github.bash $1:"
. "$HOME/buildAPKs/scripts/bash/shlibs/lock.bash"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
cd "$JDR"
if [[ ! -d "$JDR/.config" ]] 
then
	mkdir -p "$JDR/.config"
	printf "%s\\n\\n" "This directory contains results from query for \`AndroidManifest.xml\` files in GitHub $TOPNAME repositores.  " > "$JDR/.config/README.md" 
fi
if [[ ! -f "repositories.github.topic.$TOPIC+language.Java" ]] 
then
	printf "%s\\n" "Downloading GitHub $TOPNAME repositories information:  "
	if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file for information 
	then
		curl -u "$OAUT" -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:$TOPIC+language:Java" > repositories.github.topic.$TOPIC+language.Java
	else
		curl -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:$TOPIC+language:Java" > repositories.github.topic.$TOPIC+language.Java
	fi
fi
TARR=($(grep -v JavaScript repositories.github.topic.$TOPIC+language.Java | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g' | sed 's/https\:\/\/github.com\///g' | cut -d\/ -f1)) # creates array of Java language repositories
for NAME in "${TARR[@]}" 
do 
	"$RDR"/scripts/bash/build/build.github.bash "$NAME"
done

#EOF
