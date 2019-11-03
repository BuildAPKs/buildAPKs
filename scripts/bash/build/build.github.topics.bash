#!/bin/env bash
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/init/ushlibs.bash
. "$RDR"/scripts/bash/shlibs/trap.bash 77 78 79 "${0##*/}"
if [[ -z "${1:-}" ]] 
then
	printf "\\e[1;7;38;5;203m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;203m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;203m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;203m%s\\n\\e[0m\\n" "GitHub topic name must be provided;  See " "~/${RDR##*/}/var/conf/TNAMES" " for topic names that build APKs on device with BuildAPKs!  To build all the topic names contained in this file run " "for NAME in \$(cat ~/${RDR##*/}/var/conf/TNAMES) ; do ~/${RDR##*/}/scripts/bash/build/${0##*/} \$NAME ; done" ".  File " "~/${RDR##*/}/var/conf/GAUTH" " has important information should you choose to run this command regarding bandwidth supplied by GitHub. "
	exit 4
fi
if [[ -z "${NUM:-}" ]] 
then
	export NUM="$(date +%s)"
fi
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
export TOPI="${1%/}"
export TOPIC="${TOPI##*/}"
export TOPNAME="${TOPIC,,}"
export JDR="$RDR/sources/github/topics/$TOPIC"
export JID="git.$TOPIC"
export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')"
export RDR="$HOME/buildAPKs"
export STRING="ERROR FOUND; build.github.topics.bash $1:  CONTINUING... "
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "${0##*/}: Beginning BuildAPKs with build.github.topics.bash $1:"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
if [[ ! -f "$JDR"/topic ]] 
then
	printf "%s\\n" "Downloading GitHub $TOPNAME topic repositories information:"
	if [[ "$OAUT" != "" ]] # see $RDR/var/conf/GAUTH file for information 
	then
		curl -u "$OAUT" -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:$TOPIC+language:Java" -o "$JDR"/topic
	else
		curl -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:$TOPIC+language:Java" -o "$JDR"/topic
	fi
fi
TARR=($(grep -v JavaScript "$JDR"/topic | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g' | sed 's/https\:\/\/github.com\///g' | cut -d\/ -f1)) # creates array of Java language repositories for topic
for NAME in "${TARR[@]}" 
do 
	"$RDR"/scripts/bash/build/build.github.bash "$NAME"
done
. "$RDR"/scripts/bash/shlibs/lock.bash wake.stop
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
_WAKEUNLOCK_
# build.github.topics.bash EOF
