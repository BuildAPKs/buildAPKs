#!/bin/env bash
# Copyright 2019 (c) all rights reserved by BuildAPKs see LICENSE
# buildapks.github.io/buildAPKs published courtesy pages.github.com
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/init/ushlibs.bash
. "$RDR"/scripts/bash/shlibs/trap.bash 67 68 69

_AND_ () { # write configuration file for git repository tarball if AndroidManifest.xml file is found in git repositoryr.
	export CK=0
	printf "%s\\n" "$COMMIT" > "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "0" >> "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	if [[ -z "${1:-}" ]] 
	then
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  Writing ~/${RDR##*/}/sources/github/${JDR##*/}/.config/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	else
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  Downloading ${NAME##*/} tarball and writing ~/${RDR##*/}/sources/github/${JDR##*/}/.config/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	fi
}

_ATT_ () {
	if [[ "$CK" != 1 ]]
	then
		if [[ ! -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] # tar file exists
		then # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
			printf "%s\\n" "Querying $USENAME $REPO ${COMMIT::7} for AndroidManifest.xml file:"
			if [[ "$COMMIT" != "" ]] 
			then
				if [[ "$OAUT" != "" ]] # see $RDR/var/conf/GAUTH file 
				then
					ISAND="$(curl -u "$OAUT" -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1" -s 2>&1 | head -1024)" || printf "\\e[2;2;38;5;208m%s\\e[0m\\n" "ERROR FOUND in _ATT_ ISAND ${0##*/}; Continuing..."
				else
 					ISAND="$(curl -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1" -s 2>&1 | head -1024)" || printf "\\e[2;2;38;5;208m%s\\e[0m\\n" "ERROR FOUND in _ATT_ ISAND ${0##*/}; Continuing..."
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
			export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "130 $STRING"
		fi
	fi
}

_BUILDAPKS_ () { # https://developer.github.com/v3/repos/commits/
	printf "\\n%s\\n" "Getting $NAME/tarball/$COMMIT -o ${NAME##*/}.${COMMIT::7}.tar.gz:"
	if [[ "$OAUT" != "" ]] # see $RDR/var/conf/GAUTH file 
	then
		curl -u "$OAUT" -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "131 $STRING"
	else
		curl -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || printf "%s\\n\\n" "132 $STRING"
	fi
	_FJDX_ 
}

_CKAT_ () {
	CK=0
	REPO=$(awk -F/ '{print $NF}' <<< "$NAME") # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell 
	NPCK="$(find "$JDR/.config/" -name "$USER.${NAME##*/}.???????.ck")" ||: # https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
	for CKFILE in "$NPCK" 
	do
 	if [[ $CKFILE = "" ]] # configuration file is not found
 	then
 		printf "%s" "Checking $USENAME $REPO for last commit:  " 
  		COMMIT="$(_GC_)" ||:
 		printf "%s\\n" "Found ${COMMIT::7}; Continuing..."
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

_CUTE_ () { # check whether username is an organization
	. "$RDR"/scripts/bash/shlibs/lock.bash 
	. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
	read TYPE < <(curl "https://api.github.com/users/$USENAME/repos" -s 2>&1 | head -n 25 | tail -n 1 | grep -o Organization) # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell/
	if [[ "$TYPE" == Organization ]]
	then
		export ISUSER=users
		export ISOTUR=orgs
	else
		export ISUSER=users
		export ISOTUR=users
	fi
}

_FJDX_ () { 
	export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || printf "%s\\n\\n" "133 $STRING"
	(tar xvf "${NAME##*/}.${COMMIT::7}.tar.gz" | grep AndroidManifest.xml || printf "%s\\n\\n" "134 $STRING") ; _IAR_ "$JDR/$SFX" || printf "%s\\n\\n" "135 $STRING"
}

_GC_ () { 
	if [[ "$OAUT" != "" ]] # see $RDR/var/conf/GAUTH file for information  
	then # https://unix.stackexchange.com/questions/117992/download-only-first-few-bytes-of-a-source-page
	 	curl -u "$OAUT" https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' 
	else
	 	curl -r 0-1 https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' 
	fi
}

_NAND_ () { # write configuration file for repository if AndroidManifest.xml file is NOT found in git repository.  
	printf "%s\\n" "$COMMIT" > "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "1" >> "$JDR/.config/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "\\n%s\\n\\n" "Could not find an AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  NOT downloading ${NAME##*/} tarball."
}

_PRINTCK_ () {
	if [[ "$CK" = 1 ]]
	then
		printf "%s\\n\\n" "WARNING AndroidManifest.xml file not found!"
	else
		printf "%s\\n\\n" "Continuing..."
	fi
}

if [[ -z "${1:-}" ]] 
then
	printf "\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\n\\e[0m\\n" "GitHub username must be provided;  See " "~/${RDR##*/}/var/conf/UNAMES" " for usernames that build APKs on device with BuildAPKs!  To build all the usernames contained in this file run " "for NAME in \$(cat ~/${RDR##*/}/var/conf/UNAMES) ; do ~/${RDR##*/}/scripts/bash/build/${0##*/} \$NAME ; done" ".  File " "~/${RDR##*/}/var/conf/GAUTH" " has important information should you choose to run this command regarding bandwidth supplied by GitHub. "
	exit 72
fi
if [[ -z "${NUM:-}" ]] 
then
	export NUM="$(date +%s)"
fi
export UONE="${1%/}"
export USENAME="${UONE##*/}"
export USER="${USENAME,,}"
export OAUT="$(cat "$RDR/var/conf/GAUTH" | awk 'NR==1')"
export STRING="ERROR FOUND; ${0##*/} $1:  CONTINUING... "
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "${0##*/}: Beginning BuildAPKs with build.github.bash $1:"
. "$RDR"/scripts/bash/shlibs/buildAPKs/fandm.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/prep.bash
if grep -iw "$USENAME" "$RDR"/var/conf/[PZ]NAMES
then
	JDR="$RDR/sources/github/users/$USER"
	mkdir -p "$JDR"
	touch "$JDR"/repos
	printf "\\e[7;38;5;208mUsername %s is found in %s: See preceeding output.  Not processing username %s!  Remove the username from the corresponding file(s) and the user's build directory in %s to proccess %s.  File %s has more information:\\n\\n\\e[0m" "$USENAME" "~/${RDR##*/}/var/conf/[PZ]NAMES" "$USENAME" "~/${RDR##*/}/sources/github/{orgs,users}" "$USENAME" "~/${RDR##*/}/var/conf/README.md" | tee "$JDR"/README.md
	cat "$RDR/var/conf/README.md" 
	printf "\\e[7;38;5;208m\\nUsername %s is found in %s: Not processing username %s!  Remove the username from the corresponding file(s) and the user's build directory in %s to proccess %s.  Scroll up to read the %s file.\\e[0m\\n" "$USENAME" "~/${RDR##*/}/var/conf/[PZ]NAMES" "$USENAME" "~/${RDR##*/}/sources/github/{orgs,users}" "$USENAME" "~/${RDR##*/}/var/conf/README.md" | tee "$JDR"/README.md
	exit 0
else
	_CUTE_
fi
export JDR="$RDR/sources/github/$ISOTUR/$USER"
export JID="git.$ISOTUR.$USER"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
if [[ ! -d "$JDR/.config" ]] 
then
	mkdir -p "$JDR/.config"
	printf "%s\\n\\n" "This directory contains results from query for \`AndroidManifest.xml\` files in GitHub $USENAME repositores.  " > "$JDR/.config/README.md" 
fi
cd "$JDR"
if [[ ! -f "repos" ]] 
then
	printf "%s\\n" "Downloading GitHub $USENAME repositories information:  "
	if [[ "$OAUT" != "" ]] # see $RDR/var/conf/GAUTH file for information 
	then
		curl -u "$OAUT" "https://api.github.com/$ISUSER/$USER/repos" > repos
	else
		curl "https://api.github.com/$ISUSER/$USER/repos" > repos 
	fi
fi
JARR=($(grep -v JavaScript repos | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g')) # creates array of Java language repositories
F1AR=($(find . -maxdepth 1 -type d)) # creates array of $JDR contents 
for NAME in "${JARR[@]}" # lets you delete partial downloads and repopulates from GitHub.  Directories can be deleted, too.  They are repopulated from the tarballs.  
do #  This creates a "slate" within each github/$JDR that can be selectively reset when desired.  This can be important on a slow connection.
	_CKAT_ 
done
_ANDB_ "$JDR" 
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
_WAKEUNLOCK_
# build.github.bash OEF
