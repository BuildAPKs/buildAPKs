#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by buildAPKs https://buildapks.github.io/docsBuildAPKs/
# Update repository and update submodules.
#####################################################################
set -e

declare -A SBMS # Declare associative array for available submoldules. 
RDR="$HOME/buildAPKs/"
SBMS=([scripts/bash/shlibs]="$HOME/buildAPKs/scripts/bash/shlibs/.git" [sources/applications]="$HOME/buildAPKs/sources/applications/.git" [sources/browsers]="$HOME/buildAPKs/sources/browsers/.git" [sources/clocks]="$HOME/buildAPKs/sources/clocks/.git" [sources/compasses]="$HOME/buildAPKs/sources/compasses/.git" [sources/entertainment]="$HOME/buildAPKs/sources/entertainment/.git" [sources/flashlights4]="$HOME/buildAPKs/sources/flashlights4/.git" [sources/games]="$HOME/buildAPKs/sources/games/.git" [sources/live.wallpapers]="$HOME/buildAPKs/sources/live.wallpapers/.git" [sources/samples4]="$HOME/buildAPKs/sources/samples4/.git" [sources/samps]="$HOME/buildAPKs/sources/samps/.git" [sources/top10]="$HOME/buildAPKs/sources/top10/.git" [sources/tools]="$HOME/buildAPKs/sources/tools/.git" [sources/torches]="$HOME/buildAPKs/sources/torches/.git" [sources/tutorials]="$HOME/buildAPKs/sources/tutorials/.git" [sources/widgets]="$HOME/buildAPKs/sources/widgets/.git")

_2GSU_() {
	if [[ "$SBMI" = "" ]] 
	then
 		printf "\\n\\nTo update the modules in ~/buildAPKs to the newest version remove these .git files:\\n\\n"
	 	sleep 1.28
 		find "$HOME/buildAPKs/" -type f -name .git
 		printf "\\n\\nYou can use \`find\` to update the modules in ~/buildAPKs/sources to the newest version:\\n\\n"
 		printf "	$ find ~/buildAPKs/ -type f -name .git -exec rm {} \\;"
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
	printf "\\n\\nUpdating buildAPKs; \`%s\` shall attempt to load sources from Github submodule repositories into ~/buildAPKs.  This may take a little while to complete.  Please be patient while \`%s\` downloads source code from https://github.com\\n" "${0##*/}" "${0##*/}"
	(git pull 2>/dev/null && printf "\\nPlease wait: updating ~/buildAPKs...\\n") || (printf "\\nCannot update ~/buildAPKs: continuing...\\n")
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
	_GSU_ ./sources/sams 
	_GSU_ ./sources/top10 
	_GSU_ ./sources/tools 
	_GSU_ ./sources/torches
	_GSU_ ./sources/tutorials
	_GSU_ ./sources/widgets
}

_GSU_() { # update submodules to latest version
	(git submodule update --init --recursive --remote $1 2>/dev/null) ||  (printf "\\n\\n\\e[1;7;38;5;66m%s%s\\e[0m\\n" "Cannot update ~/buildAPKs${1:1}: continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
}

cd "$RDR"
_CK4MS_
_2GSU_

# pull.buildAPKs.modules.bash EOF
