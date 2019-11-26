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
. "$RDR"/scripts/bash/shlibs/lock.bash wake.lock 
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
export TOPI="${1%/}"
export TOPIC="${TOPI##*/}"
export TOPNAME="${TOPIC,,}"
export JDR="$RDR/sources/github/topics/$TOPIC"
export JID="git.$TOPIC"
export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')"
export RDR="$HOME/buildAPKs"
export STRING="ERROR FOUND; build.github.topics.bash $1:  CONTINUING... "
_RPCT_() {
	RCT="$(sed 's/\,//g' <<< "${THD[1]##*:}")" 
	RPCT="$(($RCT/100))" # repository page count
	if [[ $(($RCT%100)) -gt 0 ]] # there is a remainder
	then	# add one more page to total requested
		export RPCT="$(($RPCT+1))"
	fi
	printf "%s\\n" "Found $RPCT pages of results." 
	if [[ $RPCT -gt 10 ]] # greater than 1000 search results 
	then	# enforce https://developer.github.com/v3/search/ limit 
		printf "%s\\n" "Limiting to 10 pages of results." 
		export RPCT=10
	fi
}
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "${0##*/}: Beginning BuildAPKs with build.github.topics.bash $@:"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
if [[ ! -f "$JDR"/topic ]] 
then
	if [[ ! -z "$OAUT" ]] # see .conf/GAUTH file for information
	then	# use https://github.com/settings/tokens to create tokens
		mapfile -t THD < <(curl -u "$OAUT" -sH "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:$TOPIC+language:Java" | head -n 2 ) # total count
		RCT="$(sed 's/\,//g' <<< "${THD[1]##*:}")" 
 		_RPCT_
		until [[ $RPCT -eq 0 ]] # there are zero pages remaining
		do	# get a page of repository information
			printf "%s\\n" "Downloading GitHub $TOPNAME page $RPCT topic repositories information: "
			curl -u "$OAUT" -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?per_page=100&page=$RPCT&q=topic:$TOPIC+language:Java&sort=forks&order=desc" > "$JDR/topic.tmp"
			cat "$JDR/topic.tmp" >> "$JDR/topic"  
			RPCT="$(($RPCT-1))"
			sleep "0.${RANDOM::3}"
		done
	else
		mapfile -t THD < <(curl -sH "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?q=topic:$TOPIC+language:Java" | head -n 2 ) # total count
		RCT="$(sed 's/\,//g' <<< "${THD[1]##*:}")" 
 		_RPCT_
		until [[ $RPCT -eq 0 ]] # there are zero pages remaining
		do	# get a page of repository information
			printf "%s\\n" "Downloading GitHub $TOPNAME page $RPCT topic repositories information: "
			curl -H "Accept: application/vnd.github.mercy-preview+json" "https://api.github.com/search/repositories?per_page=100&page=$RPCT&q=topic:$TOPIC+language:Java&sort=stars&order=desc" > "$JDR/topic.tmp"
			cat "$JDR/topic.tmp" >> "$JDR/topic"  
			RPCT="$(($RPCT-1))"
			sleep "0.${RANDOM::3}"
		done
	fi
	rm -f "$JDR/topic.tmp"
fi
TARR=($(grep -v JavaScript "$JDR"/topic | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g' | sed 's/https\:\/\/github.com\///g' | cut -d\/ -f1)) # creates array of Java language repositories for topic
for NAME in "${TARR[@]}" 
do 
 	"$RDR"/scripts/bash/build/build.github.bash "$NAME"
done
. "$RDR"/scripts/bash/shlibs/lock.bash wake.stop
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
# build.github.topics.bash EOF
