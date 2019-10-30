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
	printf "%s\\n" "$COMMIT" > "$JDR/.conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "0" >> "$JDR/.conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	if [[ -z "${1:-}" ]] 
	then
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  Writing ~/${RDR##*/}/sources/github/${JDR##*/}/.conf/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	else
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  Downloading ${NAME##*/} tarball and writing ~/${RDR##*/}/sources/github/${JDR##*/}/.conf/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	fi
	_NAMESMAINBLOCK_ CNAMES QNAMES
}

_ATT_ () {
	if [[ "$CK" != 1 ]]
	then
		if [[ ! -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] # tar file exists
		then # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
			printf "%s\\n" "Querying $USENAME $REPO ${COMMIT::7} for AndroidManifest.xml file:"
			if [[ "$COMMIT" != "" ]] 
			then
				if [[ "$OAUT" != "" ]] # see $RDR/.conf/GAUTH file 
				then
					ISAND="$(curl -u "$OAUT" -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1" -s 2>&1 | head -1024)" || _SIGNAL_ "200" "_ATT_ ISAND"
				else
 					ISAND="$(curl -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1" -s 2>&1 | head -1024)" ||  _SIGNAL_ "202" "_ATT_ ISAND"
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
			export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || _SIGNAL_ "24" "_ATT_ SFX"
		fi
	fi
}

_BUILDAPKS_ () { # https://developer.github.com/v3/repos/commits/
	printf "\\n%s\\n" "Getting $NAME/tarball/$COMMIT -o ${NAME##*/}.${COMMIT::7}.tar.gz:"
	if [[ "$OAUT" != "" ]] # see $RDR/.conf/GAUTH file 
	then
		curl -u "$OAUT" -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || _SIGNAL_ "40" "_BUILDAPKS_"
	else
		curl -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || _SIGNAL_ "42" "_BUILDAPKS_"
	fi
	_FJDX_ 
}

_CKAT_ () {
	CK=0
	REPO=$(awk -F/ '{print $NF}' <<< "$NAME") # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell 
	NPCK="$(find "$JDR/.conf/" -name "$USER.${NAME##*/}.???????.ck")" ||: # https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
	for CKFILE in "$NPCK" 
	do
 	if [[ $CKFILE = "" ]] # configuration file is not found
 	then
 		printf "%s" "Checking $USENAME $REPO for last commit:  " 
  		COMMIT="$(_GC_)" || _SIGNAL_ "60" "_CKAT_ COMMIT"
 		printf "%s\\n" "Found ${COMMIT::7}; Continuing..."
 		_ATT_ 
 	else # load configuration information from file 
 		printf "%s" "Loading $USENAME $REPO config from $CKFILE:  "
 		COMMIT=$(head -n 1 "$NPCK") || _SIGNAL_ "62" "_CKAT_ COMMIT"
  		CK=$(tail -n 1  "$NPCK") || _SIGNAL_ "64" "_CKAT_ CK"
		_PRINTCK_ 
 		_ATT_ 
 	fi
done
}

_CUTE_ () { # check whether username is an organization
	. "$RDR"/scripts/bash/shlibs/lock.bash 
	. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
	mapfile -t TYPE < <(curl "https://api.github.com/users/$USER")
	if [[ "${TYPE[@]}" == *Organization* ]]
	then
		export ISUSER=users
		export ISOTUR=orgs
	else
		export ISUSER=users
		export ISOTUR=users
	fi
}

_FJDX_ () { 
	export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || _SIGNAL_ "82" "_FJDX_"
	(tar xvf "${NAME##*/}.${COMMIT::7}.tar.gz" | grep AndroidManifest.xml || _SIGNAL_ "84" "_FJDX_") ; _IAR_ "$JDR/$SFX" || _SIGNAL_ "86" "_FJDX_"
}

_GC_ () { 
	if [[ "$OAUT" != "" ]] # see $RDR/.conf/GAUTH file for information  
	then # https://unix.stackexchange.com/questions/117992/download-only-first-few-bytes-of-a-source-page
	 	curl -u "$OAUT" https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' 
	else
	 	curl -r 0-1 https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' 
	fi
}

_NAND_ () { # write configuration file for repository if AndroidManifest.xml file is NOT found in git repository.  
	printf "%s\\n" "$COMMIT" > "$JDR/.conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "1" >> "$JDR/.conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
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

_PRINTJD_() {
	printf "\\e[1;32mDONE\\e[0m\\n"
}

_PRINTJS_() {
	printf "\\n\\e[1;34mSearching for Java language repositories: "'\033]2;Searching for Java language repositories: OK\007'
}

_SIGNAL_ () {
	STRING="SIGNAL $1 found in $2 ${0##*/}!"
	printf "\\e[2;2;38;5;208m%s\\e[0m\\n\\n" "$STRING" 
}

if [[ -z "${1:-}" ]] 
then
	printf "\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\n\\e[0m\\n" "GitHub username must be provided;  See " "~/${RDR##*/}/var/db/UNAMES" " for usernames that build APKs on device with BuildAPKs!  To build all the usernames contained in this file run " "for NAME in \$(cat ~/${RDR##*/}/var/db/UNAMES) ; do ~/${RDR##*/}/scripts/bash/build/${0##*/} \$NAME ; done" ".  File " "~/${RDR##*/}/.conf/GAUTH" " has important information should you choose to run this command regarding bandwidth supplied by GitHub. "
	exit 72
fi
if [[ -z "${NUM:-}" ]] 
then
	export NUM="$(date +%s)"
fi
export UONE="${1%/}" # https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
export USENAME="${UONE##*/}"
export USER="${USENAME,,}"
export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')" # loads login:token key from GAUTH file
printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "${0##*/}: Beginning BuildAPKs with build.github.bash $1:"
. "$RDR"/scripts/bash/shlibs/buildAPKs/fandm.bash
. "$RDR"/scripts/bash/shlibs/buildAPKs/prep.bash
. "$RDR"/scripts/sh/shlibs/buildAPKs/names.sh
if grep -iw "$USENAME" "$RDR"/var/db/[PZ]NAMES
then	# create null directory, repos file and exit
	if grep -iw "$USENAME" "$RDR"/var/db/ONAMES
	then
		JDR="$RDR/sources/github/orgs/$USER"
	else
		JDR="$RDR/sources/github/users/$USER"
	fi
	mkdir -p "$JDR"
	touch "$JDR"/repos
	printf "\\e[7;38;5;208mUsername %s is found in %s: See preceeding output.  Not processing username %s!  Remove the username from the corresponding file(s) and the user's build directory in %s to proccess %s.  File %s has more information:\\n\\n\\e[0m" "$USENAME" "~/${RDR##*/}/var/db/[PZ]NAMES" "$USENAME" "~/${RDR##*/}/sources/github/{orgs,users}" "$USENAME" "~/${RDR##*/}/var/db/README.md" 
	cat "$RDR/var/db/README.md" | grep -v \<\!
	printf "\\e[7;38;5;208m\\nUsername %s is found in %s: Not processing username %s!  Remove the username from the corresponding file(s) and the user's build directory in %s to proccess %s.  Then run %s again to build %s.  Scroll up to read the %s file.\\e[0m\\n" "$USENAME" "~/${RDR##*/}/var/db/[PZ]NAMES" "$USENAME" "~/${RDR##*/}/sources/github/{orgs,users}" "$USENAME" "${0##*/}" "$USENAME" "~/${RDR##*/}/var/db/README.md" 
	exit 4
else	# check whether login is a user or an organization.
	_CUTE_
fi
export JDR="$RDR/sources/github/$ISOTUR/$USER"
export JID="git.$ISOTUR.$USER"
if [[ ! -d "$JDR" ]] 
then
	mkdir -p "$JDR"
fi
if [[ ! -d "$JDR/.conf" ]] 
then
	mkdir -p "$JDR/.conf"
	printf "%s\\n\\n" "This directory contains results from query for \` AndroidManifest.xml \` files in GitHub $USENAME repositores.  " > "$JDR/.conf/README.md" 
fi
cd "$JDR"
printf "%s" "${TYPE[@]}" > profile
if [[ ! -f "repos" ]] 
then
	printf "%s\\n" "Downloading GitHub $USENAME repositories information:  "
	if [[ "$OAUT" != "" ]] # see $RDR/.conf/GAUTH file for information 
	then
		curl -u "$OAUT" "https://api.github.com/$ISUSER/$USER/repos" > repos
	else
		curl "https://api.github.com/$ISUSER/$USER/repos" > repos 
	fi
fi
_PRINTJS_
JARR=($(grep -v JavaScript repos | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g')) # creates array of Java language repositories	
_PRINTJD_
if [[ "${JARR[@]}" == *ERROR* ]]
then
	_SIGNAL_ "404" "search for Java language repository"
	_NAMESMAINBLOCK_ CNAMES ZNAMES
	exit 0
fi
F1AR=($(find . -maxdepth 1 -type d)) # creates array of $JDR contents 
for NAME in "${JARR[@]}" # lets you delete partial downloads and repopulates from GitHub.  Directories can be deleted, too.  They are repopulated from the tarballs.  
do #  This creates a "slate" within each github/$JDR that can be selectively reset when desired.  This can be important on a slow connection.
	_CKAT_ 
done
_ANDB_ "$JDR" 
. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
_WAKEUNLOCK_
# build.github.bash OEF
