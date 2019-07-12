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

_AT_ () {
	CK=0
	REPO=$(awk -F/ '{print $NF}' <<< $NAME)
	if [[ $UR = "" ]] # config file is not present
	then
		printf "%s" "Checking $USENAME $REPO for last commit:  " 
 		COMMIT="$(_CT_)" ||:
 		_CK_ ||:
		printf "%s\\n" "Continuing..."
		_ATT_ 
	else # load config file for repository
		printf "%s" "Loading $USENAME $REPO config from ${UR}:  "
		COMMIT=$(head -n 1 "$UR")
 		CK=$(tail -n 1  "$UR")
		_PRINTCK_
		_ATT_ 
	fi
}

_PRINTCK_ () {
	if [[ "$CK" = 1 ]]
	then
		printf "%s\\n" "WARNING AndroidManifest.xml file not found!"
	else
		printf "%s\\n" "Continuing..."
	fi
}

_ATT_ () {
	if [[ "$CK" != 1 ]]
	then
		if [[ ! -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] # tests if tar file exists
		then
			printf "%s\\n" "Querying $USENAME $REPO for AndroidManifest.xml file:"
			if [[ "$COMMIT" != "" ]] 
			then
				if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file 
				then
					ISAND="$(curl -u "$OAUT" -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1")"
				else
					ISAND="$(curl -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1")"
				fi
			 	if grep AndroidManifest.xml <<< $ISAND 
				then
					_AND_
					_BUILDAPKS_
				else
					_NAND_
				fi
			elif [[ ! "${F1AR[@]}" =~ "${NAME##*/}" ]] # tests if directory exists
			then # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
				_FJDX_ 
			else
				_FJDR_ 
			fi
		elif [[ ! "${F1AR[@]}" =~ "${NAME##*/}" ]] # tests if directory exists
		then 
			_FJDX_ 
		else
			_FJDR_ 
		fi
	fi
}

_BUILDAPKS_ () { # https://developer.github.com/v3/repos/commits/	
	printf "\\n%s\\n" "Getting $NAME/tarball/$COMMIT -o ${NAME##*/}.${COMMIT::7}.tar.gz:"
	if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file for information  
	then
		curl -u "$OAUT" -L "$NAME"/tarball/$COMMIT -o "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "$STRING"
	else
		curl -L "$NAME"/tarball/$COMMIT -o "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "$STRING"
	fi
	_FJDX_ 
}

_CK_ () { 
	if [[ -f "$RDR/.conf/github/$USER.${NAME##*/}.${COMMIT::7}.ck" ]]
	then
		CK=$(tail -n 1 "$RDR/.conf/github/$USER.${NAME##*/}.${COMMIT::7}.ck")
	fi
}

_CT_ () { # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell # get tar commits
	if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file for information  
	then # https://unix.stackexchange.com/questions/117992/download-only-first-few-bytes-of-a-source-page
	 	curl -u "$OAUT" -r 0-2 https://api.github.com/repos/$USER/$REPO/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' ||:
	else
	 	curl -r 0-2 https://api.github.com/repos/$USER/$REPO/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' ||:
	fi
}

_FJDR_ () { 
	find "$JDR" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
}

_FJDX_ () { 
	export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "$STRING"
	tar xvf "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "$STRING"
	find "$JDR/$SFX" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
}

_AND_ () {
	printf "%s\\n" "$COMMIT" > "$RDR/.conf/github/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "0" >> "$RDR/.conf/github/$USER.${NAME##*/}.${COMMIT::7}.ck"
}
_NAND_ () {
	printf "%s\\n" "$COMMIT" > "$RDR/.conf/github/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "1" >> "$RDR/.conf/github/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "\\n%s\\n" "Could not find an AndroidManifest.xml file in Java language repository $USER ${NAME##*/}:  NOT DOWNLOADING ${NAME##*/} tarball."
}

export RDR="$HOME/buildAPKs"
if [[ -z "${1:-}" ]] 
then
	printf "\\n%s\\n\\n" "GitHub username must be provided;  See \`cat ~/${RDR##*/}/conf/UNAMES\` for usernames that build APKs on device with BuildAPKs!" 
	exit 227
fi
export USER="${1,,}"
export USENAME="$1"
export JDR="$RDR/sources/github/$USER"
export JID="git.$USER"
export OAUT="$(cat $RDR/conf/OAUTH | head -n 1)"
export STRING="ERROR FOUND; build.github.bash:  CONTINUING... "
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "Beginning buildAPKs with build.github.bash:"
. "$HOME/buildAPKs/scripts/shlibs/lock.bash"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
cd "$JDR"
if [[ ! -d "$RDR/.conf/github" ]] 
then
	mkdir -p "$RDR/.conf/github"
	printf "%s\\n" "This directory contains results from query for \`AndroidManifest.xml\` files in GitHub repositores.  " > "$RDR/.conf/github/README.md" 
fi
if [[ ! -f "repos" ]] 
then
	printf "%s\\n" "Downloading GitHub $USENAME repositories information:  "
	if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file for information 
	then
		curl -u "$OAUT" -O https://api.github.com/users/"$USER"/repos 
	else
		curl -O https://api.github.com/users/"$USER"/repos 
	fi
fi
JARR=($(grep -v JavaScript repos | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g')) # creates array of Java language repositories
F1AR=($(find . -maxdepth 1 -type d)) # creates array of $JDR contents 
for NAME in "${JARR[@]}"
do # lets you delete partial downloads and repopulates from GitHub.  Directories can be deleted, too.  They are repopulated from the tarballs.  This creates a "blackboard" from $JDR which can be selectively reset when desired.
	UR="$(find "$RDR"/.conf/github/ -name "$USER.${NAME##*/}.???????.ck")" ||: # https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
	_AT_ 
done

#EOF
