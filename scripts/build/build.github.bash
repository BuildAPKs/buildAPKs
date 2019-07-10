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

_BUILDAPKS_ () {
		if [[ ! -f "${NAME##*/}.$COMMIT.tar.gz" ]] # tests if tar file exists
	then
		printf "\\n%s\\n" "Getting $NAME/tarball/$COMMIT -o ${NAME##*/}.$COMMIT.tar.gz:"
		if [[ "$OAUT" != "" ]] 
		then
			curl -u "$OAUT" -L "$NAME"/tarball/$COMMIT -o "${NAME##*/}.$COMMIT.tar.gz" || printf "%s\\n\\n" "$STRING"
		else
			curl -L "$NAME"/tarball/$COMMIT -o "${NAME##*/}.$COMMIT.tar.gz" || printf "%s\\n\\n" "$STRING"
		fi
		export SFX="$(tar tf "${NAME##*/}.$COMMIT.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "$STRING"
		tar xvf "${NAME##*/}.$COMMIT.tar.gz" || printf "%s\\n\\n" "$STRING"
		find "$JDR/$SFX" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
	elif [[ ! "${F1AR[@]}" =~ "${NAME##*/}" ]] # tests if directory exists
	# https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
	then 
		export SFX="$(tar tf "${NAME##*/}.$COMMIT.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "$STRING"
		tar xvf "${NAME##*/}.$COMMIT.tar.gz" || printf "%s\\n\\n" "$STRING"
		find "$JDR/$SFX" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
	else
		find "$JDR" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
	fi
}

export RDR="$HOME/buildAPKs"
if [[ -z "${1:-}" ]] 
then
	printf "\\n%s\\n" "GitHub username must be provided;  See \`cat ~/${RDR##*/}/conf/UNAMES\` for usernames that build APKs on device with BuildAPKs!" 
	exit 227
fi
export USER="$1"
export JID="git.$USER"
export JDR="$RDR/sources/github/$USER"
export STRING="ERROR FOUND; build.github.bash:  CONTINUING... "
export OAUT="$(cat $RDR/conf/OAUTH | head -n 1)"
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "Beginning buildAPKs with build.github.bash:"
. "$HOME/buildAPKs/scripts/shlibs/lock.bash"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
cd "$JDR"
if [[ ! -f "repos" ]] 
then
	if [[ "$OAUT" != "" ]] 
	then
		curl -u "$OAUT" -O https://api.github.com/users/"$USER"/repos 
	else
		curl -O https://api.github.com/users/"$USER"/repos 
	fi
fi
JARR=($(grep -B 5 Java repos |grep svn_url|awk -v x=2 '{print $x}'|sed 's/\,//g'|sed 's/\"//g'))
F1AR=($(find . -maxdepth 1 -type d))
for NAME in "${JARR[@]}"
do # lets you delete partial downloads and repopulates from GitHub.  Directories can be deleted too.  They are repopulated from the tar files.
	REPO=$(awk -F/ '{print $NF}' <<< $NAME)
	printf "%s\\n" "Querying $USER $REPO:"
_CT_ () {
	if [[ "$OAUT" != "" ]] 
	then
	 	curl -u "$OAUT" -r 0-2 https://api.github.com/repos/$USER/$REPO/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' ||:
	else
	 	curl -r 0-2 https://api.github.com/repos/$USER/$REPO/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' ||:
	fi
}
COMMIT="$(_CT_)"
if [[ "$COMMIT" != "" ]] 
then
	printf "%s\\n" "Found last commit $COMMIT:"
	if [[ "$OAUT" != "" ]] 
	then
		ISAND="$(curl -u "$OAUT" -i "https://api.github.com/repos/$USER/$REPO/git/trees/$COMMIT?recursive=1")"
	else
		ISAND="$(curl -i "https://api.github.com/repos/$USER/$REPO/git/trees/$COMMIT?recursive=1")"
	fi
 	if grep AndroidManifest.xml <<< $ISAND 
	then
		_BUILDAPKS_
	else
		printf "%s\\n" "Could not find an AndroidManifest.xml file in this Java language repository: NOT DOWNLOADING ${NAME##*/} tarball."
	fi
fi
done

#EOF
