#!/bin/env bash
# Copyright 2019 (c) all rights reserved by BuildAPKs see LICENSE
# buildapks.github.io/buildAPKs published courtesy pages.github.com
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/init/ushlibs.bash
. "$RDR"/scripts/bash/shlibs/trap.bash 67 68 69 "${0##*/}"

_AND_ () { # writes configuration file for git repository tarball if AndroidManifest.xml file is found in git repository
	printf "%s\\n" "$COMMIT" > "$JDR/var/conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "0" >> "$JDR/var/conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	if [[ -z "${1:-}" ]] 
	then
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  Writing ~/${RDR##*/}/sources/github/${JDR##*/}/var/conf/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	else
		printf "%s\\n" "Found AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  Downloading ${NAME##*/} tarball and writing ~/${RDR##*/}/sources/github/${JDR##*/}/var/conf/$USER.${NAME##*/}.${COMMIT::7}.ck file for git repository ${NAME##*/}."
	fi
	_NAMESMAINBLOCK_ CNAMES QNAMES
}

_ATT_ () {
	if [[ "$CK" != 1 ]]
	then
		if [[ ! -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] # tar file does not exist
		then 
			printf "%s\\n" "Querying $USENAME $REPO ${COMMIT::7} for AndroidManifest.xml file:"
			if [[ "$COMMIT" != "" ]] 
			then
				if [[ -z "${CULR:-}" ]]
				then
					if [[ "$OAUT" != "" ]] 
					then
						ISAND="$(curl -s -u "$OAUT" -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1")" ||:
					else
	 					ISAND="$(curl -s -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1")" ||:
					fi
				else
					if [[ "$OAUT" != "" ]] 
					then
						ISAND="$(curl --limit-rate "$CULR" -s -u "$OAUT" -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1")" ||:
					else
	 					ISAND="$(curl --limit-rate "$CULR" -s -i "https://api.github.com/repos/$USENAME/$REPO/git/trees/$COMMIT?recursive=1")" ||:
					fi
				fi
			 	if grep AndroidManifest.xml <<< "$ISAND" 
				then
					_AND_ 0
					_BUILDAPKS_
				else
					_NAND_
				fi
			fi
		# https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
		elif [[ -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] && [[ ! "${F1AR[@]}" =~ "${NAME##*/}" ]] # tarfile exists and directory does not exist
		then
			_AND_
			_FJDX_ 
		elif [[ -f "${NAME##*/}.${COMMIT::7}.tar.gz" ]] && [[ "${F1AR[@]}" =~ "${NAME##*/}" ]] # tarfile and directory exists
		then
			_AND_
			export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || _SIGNAL_ "24" "_ATT_ SFX"
		fi
	fi
}

_BUILDAPKS_ () { # https://developer.github.com/v3/repos/commits/
	if ! grep -iw "${NAME##*/}" "$RDR"/var/db/ANAMES # repository name is not found
	then	# download tarball
		printf "\\n%s\\n" "Getting $NAME/tarball/$COMMIT -o ${NAME##*/}.${COMMIT::7}.tar.gz:"
		if [[ -z "${CULR:-}" ]]
		then
			if [[ "$OAUT" != "" ]] # see .conf/GAUTH file 
			then
				curl --fail --retry 2 -u "$OAUT" -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || _SIGNAL_ "40" "_BUILDAPKS_"
			else
				curl --fail --retry 2 -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || _SIGNAL_ "42" "_BUILDAPKS_"
			fi
		else
			if [[ "$OAUT" != "" ]] # see .conf/GAUTH file 
			then
				curl --fail --retry 2 --limit-rate "$CULR" -u "$OAUT" -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || _SIGNAL_ "40" "_BUILDAPKS_"
			else
				curl --fail --retry 2 --limit-rate "$CULR" -L "$NAME/tarball/$COMMIT" -o "${NAME##*/}.${COMMIT::7}.tar.gz" || _SIGNAL_ "42" "_BUILDAPKS_"
			fi
		fi
		_FJDX_ 
	fi
}

_CKAT_ () {
	_MKJDC_ 
	CK=0
	REPO=$(awk -F/ '{print $NF}' <<< "$NAME") # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell 
	NPCK="$(find "$JDR/var/conf/" -name "$USER.${NAME##*/}.???????.ck")" ||: # https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
	for CKFILE in "$NPCK" 
	do
 	if [[ $CKFILE = "" ]] # configuration file is not found
 	then
 		printf "%s" "Checking $USENAME $REPO for last commit:  " 
  		COMMIT="$(_GC_)" ||:
 		printf "%s\\n" "Found ${COMMIT::7}; Continuing..."
 		_ATT_ 
		sleep 0.${RANDOM::4} # eases network latency
 	else # load configuration information from file 
 		printf "%s" "Loading $USENAME $REPO config from $CKFILE:  "
 		COMMIT=$(head -n 1 "$NPCK") || _SIGNAL_ "62" "_CKAT_ COMMIT"
  		CK=$(tail -n 1  "$NPCK") || _SIGNAL_ "64" "_CKAT_ CK"
		_PRINTCK_ 
 	fi
	export CK=0
done
}

_CUTE_ () { # checks if USENAME is found in GNAMES and if it is an organization or a user
	. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
	if [[ $(grep -iw "$USENAME" "$RDR/var/db/log/GNAMES" | awk '{print $2}') == User ]] && [[ -f "$RDR/sources/github/users/$USER/profile" ]] && [[ -f "$RDR/sources/github/users/$USER/repos" ]]
	then 
		export ISUSER=users
		export ISOTUR=users
		export USENAME="$(grep -iw "$USENAME" "$RDR/var/db/log/GNAMES" | awk '{print $1}')"
		export JDR="$RDR/sources/github/$ISOTUR/$USER"
		export JID="git.$ISOTUR.$USER"
	elif [[ $(grep -iw "$USENAME" "$RDR/var/db/log/GNAMES" | awk '{print $2}') == Organization ]] && [[ -f "$RDR/sources/github/orgs/$USER/profile" ]] && [[ -f "$RDR/sources/github/orgs/$USER/repos" ]]
	then 
		export ISUSER=users
		export ISOTUR=orgs
		export USENAME="$(grep -iw "$USENAME" "$RDR/var/db/log/GNAMES" | awk '{print $1}')"
		export JDR="$RDR/sources/github/$ISOTUR/$USER"
		export JID="git.$ISOTUR.$USER"
	else	# get login and type of login from GitHub
		mapfile -t TYPE < <(curl "https://api.github.com/users/$USENAME")
		if [[ "${TYPE[1]}" == *\"message\":\ \"Not\ Found\"* ]]
		then
			printf "\\n%s\\n\\n" "Could not find a GitHub login with $USENAME:  Exiting..."
			exit 44
		fi
		(if [[ -z "${TYPE[17]}" ]] 
		then
			_SIGNAL_ "71" "${TYPE[17]} undefined!" "71"
			exit 34
		fi) || (_SIGNAL_ "72" "TYPE[17]: unbound variable" "72")
		export USENAME="$(printf "%s" "${TYPE[1]}" | sed 's/"//g' | sed 's/,//g' | awk '{print $2}')" || _SIGNAL_ "73" "_CUTE_ \$USENAME"
		export NAPKS="$(printf "%s" "${TYPE[17]}" | sed 's/"//g' | sed 's/,//g' | awk '{print $2}')" || (_SIGNAL_ "74" "_CUTE_ \$NAPKS: create \$NAPKS failed; Exiting..." 24)
		if [[ "${TYPE[17]}" == *User* ]]
		then
			export ISUSER=users
			export ISOTUR=users
		else
			export ISUSER=users
			export ISOTUR=orgs
		fi
		export JDR="$RDR/sources/github/$ISOTUR/$USER"
		export JID="git.$ISOTUR.$USER"
		if [[ ! -d "$JDR" ]] 
		then
			mkdir -p "$JDR"
		fi
		printf "%s\\n" "${TYPE[@]}" > "$JDR"/profile
		_MKJDC_ 
		_NAMESMAINBLOCK_ CNAMES GNAMES log/GNAMES
	fi
	printf "%s\\n" "Processing $USENAME:"
	KEYT=("\"login\"" "\"id\"" "\"type\"" "\"name\"" "\"company\"" "\"blog\"" "\"location\"" "\"hireable\"" "\"bio\"" "\"public_repos\"" "\"public_gists\"" "\"followers\"" "\"following\"" "\"created_at\"" )
	for KEYS in "${KEYT[@]}" # print selected information from profile file 
	do
		grep "$KEYS" "$JDR/profile" | sed 's/\,//g' | sed 's/\"//g'
	done
	RCT="$(grep public_repos "$JDR/profile" | sed 's/\,//g' | sed 's/\"//g' | awk '{print $2}')" # repository count
	RPCT="$(($RCT/100))" # repository page count
	if [[ $(($RCT%100)) -gt 0 ]] # there is a remainder
	then	# add one more page to total reqest
		RPCT="$(($RPCT+1))"
	fi
	if [[ ! -f "$JDR/repos" ]] # file repos does not exist 
	then	# get repository information
		until [[ $RPCT -eq 0 ]] # there are zero pages remaining
		do	# get a page of repository information
			printf "%s\\n" "Downloading GitHub $USENAME page $RPCT repositories information: "
			if [[ -z "${CULR:-}" ]] # curl --limit-rate is not set
			then
				if [[ "$OAUT" != "" ]] # see .conf/GAUTH file for information 
				then
					curl --fail --retry 2 -u "$OAUT" "https://api.github.com/$ISUSER/$USER/repos?per_page=100&page=$RPCT" > "$JDR/var/conf/repos.tmp" 
					cat "$JDR/var/conf/repos.tmp" >> "$JDR/repos"  
				else
					curl --fail --retry 2 "https://api.github.com/$ISUSER/$USER/repos?per_page=100&page=$RPCT" > "$JDR/var/conf/repos.tmp"
					cat "$JDR/var/conf/repos.tmp" >> "$JDR/repos"  
				fi
			else
				if [[ "$OAUT" != "" ]] 
				then
					curl --fail --retry 2 --limit-rate "$CULR" -u "$OAUT" "https://api.github.com/$ISUSER/$USER/repos?per_page=100&page=$RPCT" > "$JDR/var/conf/repos.tmp"
					cat "$JDR/var/conf/repos.tmp" >> "$JDR/repos"  
				else
					curl --fail --retry 2 --limit-rate "$CULR" "https://api.github.com/$ISUSER/$USER/repos?per_page=100&page=$RPCT" > "$JDR/var/conf/repos.tmp"
					cat "$JDR/var/conf/repos.tmp" >> "$JDR/repos"  
				fi
			fi
			rm -f "$JDR"/var/conf/repos.tmp
			RPCT="$(($RPCT-1))"
		done
	fi
}

_MKJDC_ () { 
	if [[ ! -d "$JDR/var/conf" ]] 
	then
		mkdir -p "$JDR/var/conf"
		printf "%s\\n\\n" "This directory contains results from query for \` AndroidManifest.xml \` files in GitHub $USENAME repositores.  
		| file name | purpose |
		-----------------------
		| *.ck      | commit and AndroidManifest.xml query result | 
		| NAMES.db  | NAMES files proccessed | 
		| NAMFS.db  | number of AndroidManifest.xml files found | 
		| NAPKS.db  | number of APKs built |  " > "$JDR/var/conf/README.md" 
	fi
}

_FJDX_ () { 
	export SFX="$(tar tf "${NAME##*/}.${COMMIT::7}.tar.gz" | awk 'NR==1' )" || _SIGNAL_ "82" "_FJDX_"
	(tar xvf "${NAME##*/}.${COMMIT::7}.tar.gz" | grep AndroidManifest.xml || _SIGNAL_ "84" "_FJDX_") ; _IAR_ "$JDR/$SFX" || _SIGNAL_ "86" "_FJDX_"
}

_GC_ () { 
	if [[ "$OAUT" != "" ]] # see .conf/GAUTH file for information  
	then # https://unix.stackexchange.com/questions/117992/download-only-first-few-bytes-of-a-source-page
	 	curl -u "$OAUT" https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' 
	else
	 	curl https://api.github.com/repos/"$USER/$REPO"/commits -s 2>&1 | head -n 3 | tail -n 1 | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//g' 
	fi
}

_MAINGITHUB_ () {
	if [[ -z "${NUM:-}" ]] 
	then
		export NUM="$(date +%s)"
	fi
	export USENAME="${UONE##*/}"
	export USER="${USENAME,,}"
	export OAUT="$(cat "$RDR/.conf/GAUTH" | awk 'NR==1')" # loads login:token key from GAUTH file
	export WRAMES=0
	printf "\\n\\e[1;38;5;116m%s\\n\\e[0m" "${0##*/}: Beginning BuildAPKs with build.github.bash $@:"
	. "$RDR"/scripts/bash/shlibs/buildAPKs/fandm.bash
	. "$RDR"/scripts/bash/shlibs/buildAPKs/prep.bash
	. "$RDR"/scripts/sh/shlibs/buildAPKs/fapks.sh
	. "$RDR"/scripts/sh/shlibs/buildAPKs/names.sh 0
	. "$RDR"/scripts/sh/shlibs/mkfiles.sh
	. "$RDR"/scripts/sh/shlibs/mkdirs.sh
	_MKDIRS_ "cache/stash" "cache/tarballs" "db" "db/log" "log/messages"
	_MKFILES_ "db/ANAMES" "db/BNAMES" "db/B10NAMES" "db/B100NAMES" "db/CNAMES" "db/GNAMES" "db/QNAMES" "db/RNAMES" "db/XNAMES" "db/ZNAMES" "db/log/BNAMES" "db/log/B10NAMES" "db/log/B100NAMES" "db/log/GNAMES"
	if grep -Hiw "$USENAME" "$RDR"/var/db/[PRXZ]NAMES
	then	# create null directory, profile, repos files, and exit
		if grep -iw "$USENAME" "$RDR"/var/db/ONAMES 1>/dev/null
		then
			JDR="$RDR/sources/github/orgs/$USER"
		else
			JDR="$RDR/sources/github/users/$USER"
		fi
		mkdir -p "$JDR" # create null directory
		touch "$JDR"/profile # create null profile file 
		touch "$JDR"/repos # create null repos file 
		printf "\\e[7;38;5;204mUsername %s is found in %s: NOT processing download and build for username %s!  Remove the login from the corresponding file(s) and the account's build directory in %s if an empty directory was created to process %s.  Then run \` %s \` again to attempt to build %s's APK projects, if any.  File %s has more information:\\e[0m\\n" "$USENAME" "~/${RDR##*/}/var/db/[PRXZ]NAMES" "$USENAME" "~/${RDR##*/}/sources/github/{orgs,users}" "$USENAME" "${0##*/} $USENAME" "$USENAME" "~/${RDR##*/}/var/db/README.md" 
		awk 'NR>=16 && NR<=41' "$RDR/var/db/README.md" 
		printf "\\e[7;38;5;203mUsername %s is found in %s: NOT processing download and build for username %s!  Remove the username from the corresponding file(s) and the account's build directory in %s if an empty directory was created to process %s.  Then run \` %s \` again to attempt to build %s's APK projects, if any.  Scroll up to read information from the %s file.\\e[0m\\n" "$USENAME" "~/${RDR##*/}/var/db/[PRXZ]NAMES" "$USENAME" "~/${RDR##*/}/sources/github/{orgs,users}" "$USENAME" "${0##*/} $USENAME" "$USENAME" "~/${RDR##*/}/var/db/README.md" 
		exit 0 # and exit
	else	# check whether login is a user or an organization
		_CUTE_
	fi
	_PRINTJS_
	JARR=($(grep -v JavaScript "$JDR/repos" | grep -B 5 Java | grep svn_url | awk -v x=2 '{print $x}' | sed 's/\,//g' | sed 's/\"//g')) ||: # creates array of Java language repositories	
	_PRINTJD_
	if [[ "${JARR[@]}" == *ERROR* ]]
	then
		_NAMESMAINBLOCK_ CNAMES ZNAMES
		_SIGNAL_ "404" "search for Java language repositories" "4"
	fi
	F1AR=($(find "$JDR" -maxdepth 1 -type d)) # creates array of JDR contents 
	cd "$JDR"
	_PRINTAS_
	for NAME in "${JARR[@]}" # lets you delete partial downloads and repopulates from GitHub.  Directories can be deleted, too.  They are repopulated from the tarballs.  
	do #  This creates a "slate" within each github/$JDR that can be selectively reset when desired.  This can be important on a slow connection.
		_CKAT_ 
	done
	_PRINTJD_
	_ANDB_ 
	_APKBC_
	. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.gt 
}

_NAND_ () { # writed configuration file for repository if AndroidManifest.xml file is NOT found in git repository
	printf "%s\\n" "$COMMIT" > "$JDR/var/conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "%s\\n" "1" >> "$JDR/var/conf/$USER.${NAME##*/}.${COMMIT::7}.ck"
	printf "\\n%s\\n\\n" "Could not find an AndroidManifest.xml file in Java language repository $USER ${NAME##*/} ${COMMIT::7}:  NOT downloading ${NAME##*/} tarball."
}

_PRINTAS_ () {
	printf "\\e[1;34mSearching for AndroidManifest.xml files:\\e[0m\\n"'\033]2;Searching for AndroidManifest.xml files: OK\007'
}

_PRINTCK_ () {
	if [[ "$CK" = 1 ]]
	then
		printf "%s\\n\\n" "WARNING AndroidManifest.xml file not found!"
	else
		printf "%s\\n\\n" "Continuing..."
	fi
}

_PRINTJD_ () {
	printf "\\e[1;32mDONE\\e[0m\\n"
}

_PRINTJS_ () {
	printf "\\n\\e[1;34mSearching for Java language repositories: "'\033]2;Searching for Java language repositories: OK\007'
}

_SIGNAL_ () {
 	if [[ -z ${3:-} ]]
	then
		STRING="SIGNAL $1 found in $2 ${0##*/} build.github.bash!  Continuing..."
		printf "\\e[2;7;38;5;210m%s\\e[0m" "$STRING" 
	else
		SG=$3
		STRING="EXIT SIGNAL $1 recieved in $2 ${0##*/} build.github.bash!  Exiting..."
		printf "\\e[2;7;38;5;210m%s\\e[0m" "$STRING" 
		exit $SG
	fi
}

if [[ -z "${1:-}" ]] # no argument is given
then	# print message and exit
	printf "\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\e[1;7;38;5;201m%s\\e[1;7;38;5;204m%s\\n\\e[0m\\n" "GitHub username must be provided;  See " "~/${RDR##*/}/var/db/UNAMES" " for usernames that build APKs on device with BuildAPKs!  To build all the usernames contained in this file run " "for NAME in \$(cat ~/${RDR##*/}/var/db/UNAMES) ; do ~/${RDR##*/}/scripts/bash/build/${0##*/} \$NAME ; done" ".  File " "~/${RDR##*/}/.conf/GAUTH" " has important information should you choose to run this command regarding bandwidth supplied by GitHub. "
	exit 68
fi
export UONE="${1%/}" # https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
if [[ ! -z "${2:-}" ]] # a second argument is given
then	# check if the second argument begins with these letter combinations: [[c|ct] rate] limit download transmission rate for curl.
	if [[ "${2//-}" = [Cc]* ]] || [[ "${2//-}" = [Cc][Tt]* ]] # the second argument begins with these letters
	then	# the third argument is required, e.g. [512] [1024] [2048]
		if [[ ! -z "${3:-}" ]] # third argument is defined
		then	# use argument $3 and limit download transmission rate for curl
			CULR="$3"
			_MAINGITHUB_ "$*"
		else	# print message and exit
			printf "\\e[0;31m%s\\e[1;31m%s\\e[0;31m%s\\e[1;31m%s\\e[0;31m%s\\e[7;31m%s\\e[0m\\n" "Add a numerical rate limit to " "${0##*/} $1 $2 " "as the third argument to continue with curl --rate-limit, i.e. " "${0##*/} $1 $2 16384" ":" " Exiting..."
			exit 64
		fi
	fi
else
	_MAINGITHUB_ "$*"
fi
# build.github.bash OEF
