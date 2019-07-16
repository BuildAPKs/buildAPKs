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

_AND_ () { # write configuration file for git repository tarball if AndroidManifest.xml file is found in git repositoryr.
	export CK=0
	printf "%s\\n" "$COMMIT" > "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "0" >> "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	if [[ -z "${1:-}" ]] 
	then
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/}:  Writing ~/${RDR##*/}/sources/github/${JDR##*/}/.config/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	else
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/}:  Downloading ${NAME##*/} tarball and writing ~/${RDR##*/}/sources/github/${JDR##*/}/.config/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	fi
}

_NAND_ () { # write configuration file for repository if AndroidManifest.xml file is NOT found in git repository.  
	printf "%s\\n" "$COMMIT" > "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "1" >> "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "\\n%s\\n\\n" "Could not find an AndroidManifest.xml file in Java language repository $USER ${NAME##*/}:  NOT downloading ${NAME##*/} tarball."
}

_AT_ () {
	CK=0
	REPO=$(awk -F/ '{print $NF}' <<< "$NAME") # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell 
	NPCK="$(find "$JDR/.config/" -name "$USER.${NAME##*/}.???????.ck")" ||: # https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
	for CKFILE in "$NPCK" 
	do
 	if [[ $CKFILE = "" ]] # configuration file is not found
 	then
 		printf "%s" "Checking $USENAME $REPO for last commit:  " 
  		COMMIT="$(_GC_)" ||:
 		printf "%s\\n" "Continuing..."
 		_ATT_ 
 	else # load configuration information from file 
 		printf "%s" "Loading $USENAME $REPO config from $CKFILE:  "
 		COMMIT=$(head -n 1 "$NPCK")
  		CK=$(tail -n 1  "$NPCK")
		_PRINTCK_ 
 		_ATT_ 
 	fi
done
}

_ATT_ () {
	if [[ "$CK" != 1 ]]
	then
		if [[ ! -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] # tar file exists
		then # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
			printf "%s\\n" "Querying $USENAME $REPO for AndroidManifest.xml file:"
			if [[ "$COMMIT" != "" ]] 
			then
				if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file 
				then
 					ISAND="$(curl -u "$OAUT" -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1" -s 2>&1 | head -n 420 ||:)"
				else
 					ISAND="$(curl -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1" -s 2>&1 | head -n 420 ||:)"
				fi
			 	if grep AndroidManifest.xml <<< "$ISAND" 
				then
					_AND_ 0
					_BUILDAPKS_
				else
					_NAND_
				fi
			fi
		elif [[ -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] && [[ ! "${F1AR[@]}" =~ "${NAME##*/}" ]] # tarfile exists and directory does not exist
		then
			_AND_
			_FJDX_ 
		elif [[ -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] && [[ "${F1AR[@]}" =~ "${NAME##*/}" ]] # tarfile and directory exist
		then
			_AND_
			export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "$STRING"
		  	find "$JDR/$SFX" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/bash/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
		fi
	fi
}

_BUILDAPKS_ () { # https://developer.github.com/v3/repos/commits/
	printf "\\n%s\\n" "Getting $NAME/tarball/$COMMIT -o ${NAME##*/}.${COMMIT::7}.tar.gz:"
	if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file 
	then
		curl -u "$OAUT" -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "$STRING"
	else
		curl -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "$STRING"
	fi
	_FJDX_ 
}

_FJDX_ () { 
	export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "$STRING"
  	tar xvf "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "$STRING"
  	find "$JDR/$SFX" -name AndroidManifest.xml -execdir /bin/bash "$HOME/buildAPKs/scripts/bash/build/build.one.bash" "$JID" "$JDR" {} \; 2>>"$HOME/buildAPKs/log/stnderr.${JID,,}.log" || printf "%s\\n\\n" "$STRING"
}

_GC_ () { 
	if [[ "$OAUT" != "" ]] # see $RDR/conf/OAUTH file for information  
	then # https://unix.stackexchange.com/questions/117992/download-only-first-few-bytes-of-a-source-page
	 	curl -u "$OAUT" https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' ||:
	else
	 	curl -r 0-1 https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' ||:
	fi
}

_PRINTCK_ () {
	if [[ "$CK" = 1 ]]
	then
		printf "%s\\n\\n" "WARNING AndroidManifest.xml file not found!"
	else
		printf "%s\\n\\n" "Continuing..."
	fi
}

export RDR="$HOME/buildAPKs"
if [[ -z "${1:-}" ]] 
then
	printf "\\n%s\\n\\n" "GitHub username must be provided;  See \`cat ~/${RDR##*/}/conf/UNAMES\` for usernames that build APKs on device with BuildAPKs!  To build all the user names contained in this file type, \`$ for i in \$(cat ~/${RDR##*/}/conf/UNAMES ) ; do ~/${RDR##*/}/scripts/bash/build/build.github.bash \$i ; done\`."
	exit 227
fi
export UON="${1%/}"
export UONE="${UON##*/}"
export USENAME="$UONE"
export USER="${USENAME,,}"
export JDR="$RDR/sources/github/$USER"
export JID="git.$USER"
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
	printf "%s\\n\\n" "This directory contains results from query for \`AndroidManifest.xml\` files in GitHub $USENAME repositores.  " > "$JDR/.config/README.md" 
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
for NAME in "${JARR[@]}" # lets you delete partial downloads and repopulates from GitHub.  Directories can be deleted, too.  They are repopulated from the tarballs.  
do #  This creates a "slate" within each github/$JDR that can be selectively reset when desired.  This can be important on a slow connection.
	_AT_ 
done

#EOF
