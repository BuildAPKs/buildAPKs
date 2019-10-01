#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by buildAPKs https://buildapks.github.io/docsBuildAPKs/
# Update repository and update submodules.
#####################################################################
set -e

declare -A SBMS # Declare associative array for available submoldules. 
RDR="$HOME/buildAPKs/"
SBMS=([scripts/bash/shlibs]="$RDR/scripts/bash/shlibs/.git" [sources/applications]="$RDR/sources/applications/.git" [sources/browsers]="$RDR/sources/browsers/.git" [sources/clocks]="$RDR/sources/clocks/.git" [sources/compasses]="$RDR/sources/compasses/.git" [sources/entertainment]="$RDR/sources/entertainment/.git" [sources/flashlights4]="$RDR/sources/flashlights4/.git" [sources/games]="$RDR/sources/games/.git" [sources/live.wallpapers]="$RDR/sources/live.wallpapers/.git" [sources/samples4]="$RDR/sources/samples4/.git" [sources/samps]="$RDR/sources/samps/.git" [sources/top10]="$RDR/sources/top10/.git" [sources/tools]="$RDR/sources/tools/.git" [sources/torches]="$RDR/sources/torches/.git" [sources/tutorials]="$RDR/sources/tutorials/.git" [sources/widgets]="$RDR/sources/widgets/.git")

_2GSU_() {
	if [[ "$SBMI" = "" ]] 
	then
 		printf "\\nTo update the modules in ~/buildAPKs to the newest version remove these .git files:\\n\\n"
	 	sleep 1.28
 		find "$RDR" -type f -name .git
 		printf "\\n\\nYou can use \`find\` to update the modules in ~/buildAPKs/sources to the newest version:\\n\\n"
 		printf "	$ find ~/buildAPKs/sources -type f -name .git -delete"
 		printf "\\n\\nThen execute %s again, and %s shall attempt to update all of them.\\n\\n" "${0##*/}" "${0##*/}"
	 	sleep 1.28
	else
		_GSMU_
	fi
}

_CK4MS_() { # ChecKs 4 ModuleS 
	SBMI=""
	for loc in "${!SBMS[@]}" 
	do
		if [[ ! -f "${SBMS[$loc]}" ]] 
		then
			SBMI=1
			break
		fi
	done
}

_GSMU_() {	
	printf "\\nUpdating buildAPKs; \`%s\` shall attempt to load sources from Github submodule repositories into ~/buildAPKs.  This may take a little while to complete.  Please be patient while \`%s\` downloads source code from https://github.com\\n" "${0##*/}" "${0##*/}"
	(git pull 2>/dev/null && printf "\\nPlease wait; Updating ~/buildAPKs...\\n") || (printf "\\nCannot update ~/buildAPKs: Continuing...\\n")
	_GSU_ ./scripts/bash/shlibs
	_GSU_ ./sources/applications
	_GSU_ ./sources/browsers 
	_GSU_ ./sources/clocks
	_GSU_ ./sources/compasses 
	_GSU_ ./sources/entertainment
	_GSU_ ./sources/flashlights4
	_GSU_ ./sources/games 
	_GSU_ ./sources/live.wallpapers
	_GSU_ ./sources/samples4
	_GSU_ ./sources/samps 
	_GSU_ ./sources/top10 
	_GSU_ ./sources/tools 
	_GSU_ ./sources/torches
	_GSU_ ./sources/tutorials
	_GSU_ ./sources/widgets
}

_GSU_() { # update submodules to latest version
	(git submodule update --init --recursive --remote $1 2>/dev/null) ||  (printf "\\n\\n\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot update ~/buildAPKs${1:1}: Continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
}

cd "$RDR"
_CK4MS_
_2GSU_
printf "\\nBuildAPKs %s: DONE!\\n\\n" "${0##*/}"

# pull.buildAPKs.modules.bash EOF
