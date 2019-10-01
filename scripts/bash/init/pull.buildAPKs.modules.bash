#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by buildAPKs https://buildapks.github.io/docsBuildAPKs/
# Update repository and update submodules.
#####################################################################
set -e

declare -A SBMS # Declare associative array for available submoldules. 
RDR="$HOME/buildAPKs"
SBMS=([scripts/bash/shlibs]="$RDR/scripts/bash/shlibs/.git" [sources/applications]="$RDR/sources/applications/.git" [sources/browsers]="$RDR/sources/browsers/.git" [sources/clocks]="$RDR/sources/clocks/.git" [sources/compasses]="$RDR/sources/compasses/.git" [sources/entertainment]="$RDR/sources/entertainment/.git" [sources/flashlights4]="$RDR/sources/flashlights4/.git" [sources/games]="$RDR/sources/games/.git" [sources/live.wallpapers]="$RDR/sources/live.wallpapers/.git" [sources/samples4]="$RDR/sources/samples4/.git" [sources/samps]="$RDR/sources/samps/.git" [sources/top10]="$RDR/sources/top10/.git" [sources/tools]="$RDR/sources/tools/.git" [sources/torches]="$RDR/sources/torches/.git" [sources/tutorials]="$RDR/sources/tutorials/.git" [sources/widgets]="$RDR/sources/widgets/.git")

_2GSU_() {
	if [[ "$SBMI" = "" ]] 
	then
 		printf "To update the modules in ~/buildAPKs to the newest version remove these .git files:\\n\\n"
		for GLOC in "${SBMS[@]}" 
		do
			printf "%s\\n" "$GLOC" 
		done
 		printf "\\nUse find to update the modules in ~/buildAPKs/sources/ to the newest version:\\n\\n"
 		printf "	$ find ~/buildAPKs/sources/ -type f -name .git -delete"
 		printf "\\n\\nThen run %s again, and %s shall attempt to update all of them.\\n" "${0##*/}" "${0##*/}"
	else
		_GSMU_
	fi
	printf "\\nBuildAPKs %s: DONE!\\n" "${0##*/}"
}

_CK4MS_() { # ChecKs 4 ModuleS 
	SBMI=""
	for LOC in "${!SBMS[@]}" 
	do
		if [[ ! -f "${SBMS[$LOC]}" ]] 
		then
			SBMI=1
			break
		fi
	done
}

_GSMU_() {	
	printf "\\nUpdating buildAPKs; \`%s\` shall attempt to load sources from Github submodule repositories into ~/buildAPKs.  This may take a little while to complete.  Please be patient while \`%s\` downloads source code from https://github.com\\n" "${0##*/}" "${0##*/}"
	(git pull 2>/dev/null && printf "\\nPlease wait; Updating ~/buildAPKs...\\n") || (printf "\\nCannot update ~/buildAPKs:  Continuing...\\n")
	for LOC in "${!SBMS[@]}" 
	do
		_GSU_ $LOC
	done
}

_GSU_() { # update submodules to latest version
	(git submodule update --init --recursive --remote $1 2>/dev/null) ||  (printf "\\n\\n\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot update ~/buildAPKs/$1:  Continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
}

cd "$RDR/"
_CK4MS_
_2GSU_

# pull.buildAPKs.modules.bash EOF
