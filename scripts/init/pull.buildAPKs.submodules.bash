#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update repository and update submodules.
#####################################################################
set -e

declare -A SBMS # Declare associative array for available submoldules. 
RDR="$HOME/buildAPKs/"
SBMS=([docs]="$HOME/buildAPKs/docs/.git" [scripts/shlibs]="$HOME/buildAPKs/scripts/shlibs/.git" [sources/applications]="$HOME/buildAPKs/sources/applications/.git" [sources/browsers]="$HOME/buildAPKs/sources/browsers/.git" [sources/clocks]="$HOME/buildAPKs/sources/clocks/.git" [sources/compasses]="$HOME/buildAPKs/sources/compasses/.git" [sources/entertainment]="$HOME/buildAPKs/sources/entertainment/.git" [sources/flashlights]="$HOME/buildAPKs/sources/flashlights/.git" [sources/games]="$HOME/buildAPKs/sources/games/.git" [sources/livewallpapers]="$HOME/buildAPKs/sources/livewallpapers/.git" [sources/samples]="$HOME/buildAPKs/sources/samples/.git" [sources/top10]="$HOME/buildAPKs/sources/top10/.git" [sources/tools]="$HOME/buildAPKs/sources/tools/.git" [sources/tutorials]="$HOME/buildAPKs/sources/tutorials/.git" [sources/widgets]="$HOME/buildAPKs/sources/widgets/.git")

_GSU_() { # Update submodules to latest version. 
	(git submodule update --init --recursive --remote $1 2>/dev/null) ||  (printf "\\n\\n\\e[1;7;38;5;66m%s%s\\e[0m\\n" "Cannot update ~/buildAPKs${1:1}: continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
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

_2GSU_() {
	if [[ "$SBMI" = "" ]] 
	then
 		printf "\\n\\nTo update the modules in ~/buildAPKs to the newest version remove these .git files:\\n\\n"
	 	sleep 1.28
 		find "$HOME/buildAPKs/" -type f -name .git
 		printf "\\n\\nYou can use \`find\` to update the modules in ~/buildAPKs/sources to the newest version:\\n\\n"
 		printf "	$ find ~/buildAPKs -type f -name .git -exec rm {} \\;"
 		printf "\\n\\nThen execute %s again, and %s shall attempt to update all of them.\\n\\n" "${0##*/}" "${0##*/}"
	 	sleep 1.28
	else
		_GSMU_
	fi
}

_GSMU_() {	
	printf "\\n\\nUpdating buildAPKs; \`%s\` shall attempt to load sources from Github submodule repositories into ~/buildAPKs.  This may take a little while to complete.  Please be patient while \`%s\` downloads source code from https://github.com\\n" "${0##*/}" "${0##*/}"
	(git pull 2>/dev/null && printf "\\nPlease wait: loading submodules...\\n") || (printf "\\nCannot update ~/buildAPKs: continuing...\\n")
	_GSU_ ./docs
	_GSU_ ./scripts/shlibs
	_GSU_ ./sources/applications
	_GSU_ ./sources/browsers 
	_GSU_ ./sources/clocks
	_GSU_ ./sources/compasses 
	_GSU_ ./sources/entertainment
	_GSU_ ./sources/flashlights 
	_GSU_ ./sources/games 
	_GSU_ ./sources/livewallpapers
	_GSU_ ./sources/samples 
	_GSU_ ./sources/top10 
	_GSU_ ./sources/tools 
	_GSU_ ./sources/tutorials
	_GSU_ ./sources/widgets
}

cd "$RDR"
_CK4MS_
_2GSU_

#EOF
