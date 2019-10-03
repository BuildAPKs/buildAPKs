#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by buildAPKs https://buildapks.github.io/docsBuildAPKs/
# Update repository and update submodules.
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SPTRPERROR_() { # run on script error
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs pull.buildAPKs.modules.bash %s WARNING:  Error %s received!\\e[0m\\n" "${0##*/}" "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs pull.buildAPKs.modules.bash %s %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${0##*/}" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 147
}

_SPTRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SPTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs pull.buildAPKs.modules.bash %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
        printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs pull.buildAPKs.modules.bash %s WARNING:  Signal %s received near or at line number %s by \`%s\`!\\e[0m\\n" "${0##*/}" "${1:-UNDEFINED}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
 	exit 148 
}

_SPTRPQuIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs pull.buildAPKs.modules.bash %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
        printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs pull.buildAPKs.modules.bash %s WARNING:  Quit signal %s received near or at line number %s by \`%s\`!\\e[0m\\n" "${0##*/}" "${1:-UNDEFINED}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
 	exit 149 
}

trap '_SPTRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SPTRPEXIT_ EXIT
trap '_SPTRPSIGNAL_ $? $LINENO $BASH_COMMAND'  HUP INT TERM
trap '_SPTRPQuIT_ $? $LINENO $BASH_COMMAND' QUIT 

declare -A GBMS # declare associative array for available submoldules
RDR="$HOME/buildAPKs"
SADD="https://github.com"
GBMS=([scripts/bash/shlibs]="shlibs/shlibs.bash" [sources/applications]="SDRausty/buildAPKsApps"  [sources/apps]="BuildAPKs/buildAPKs.apps" [sources/browsers]="SDRausty/buildAPKsBrowsers" [sources/clocks]="BuildAPKs/buildAPKs.clocks" [sources/compasses]="BuildAPKs/buildAPKs.compasses" [sources/entertainment]="BuildAPKs/buildAPKs.entertainment" [sources/flashlights4]="BuildAPKs/buildAPKs.flashlights" [sources/gamez]="BuildAPKs/buildAPKs.games"  [sources/gaming]="SDRausty/buildAPKsGames" [sources/live.wallpapers]="BuildAPKs/buildAPKs.live.wallpapers" [sources/samples4]="SDRausty/buildAPKsSamples" [sources/samps]="BuildAPKs/buildAPKs.samples" [sources/top10]="SDRausty/buildAPKsTop10" [sources/tools]="BuildAPKs/buildAPKs.developers.tools" [sources/torches]="SDRausty/buildAPKsFlashlights" [sources/tutorials]="SDRausty/buildAPKsTutorials" [sources/widgets]="SDRausty/buildAPKsWidgets")

_2GSU_() {
	if [[ "$SBMI" = "" ]] 
	then
 		printf "To update the modules in ~/buildAPKs to the newest version remove these .git files:\\n\\n"
		for GLOC in "${!GBMS[@]}" 
		do
			printf "%s\\n" "~/${RDR##*/}/$GLOC/.git" 
		done
 		printf "\\nUse find to update the modules in ~/buildAPKs/sources/ to the newest version:\\n\\n"
 		printf "	$ find ~/buildAPKs/sources/ -type f -name .git -delete"
 		printf "\\n\\nThen run %s again, and %s shall attempt to update them all!\\n" "${0##*/}" "${0##*/}"
	else
		_GSMU_
	fi
	printf "\\nBuildAPKs %s: DONE!\\n" "${0##*/}"
}

_CK4MS_() { # ChecKs 4 ModuleS 
	SBMI=""
	for ALOC in "${!GBMS[@]}" 
	do
		if [[ ! -f "${RDR}/$ALOC/.git" ]] 
		then
			SBMI=1
			break
		fi
	done
}

_GSMU_() {	
	printf "Updating buildAPKs; \`%s\` shall attempt to load sources from Github submodule repositories into ~/buildAPKs.  This may take a little while to complete.  Please be patient while \`%s\` downloads source code from https://github.com\\n\\n" "${0##*/}" "${0##*/}"
# 	(printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Updating ~/buildAPKs..." && git pull) ||  (printf "\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot update ~/buildAPKs:  Continuing...")
	for LOC in "${!GBMS[@]}" 
	do
		_GSU_ 
	done
}

_GSA_() { # update submodules to latest version
	(printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Adding https://github.com/${GBMS[$LOC]} to ~/buildAPKs/$LOC..." && git submodule add https://github.com/${GBMS[$LOC]} $LOC) ||  (printf "\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot add ~/buildAPKs/$LOC:  Continuing...") 
}

_GSU_() { # update submodules to latest version
	( (printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Updating ~/buildAPKs/$LOC..." && git submodule update --init --recursive --remote $LOC ) || ( _GSA_ ) ) ||  (printf "\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot update ~/buildAPKs/$LOC:  Continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
}

cd "$RDR/"
if [[ ! -d "$RDR/sources" ]]
then
	mkdir -p "$RDR/sources"
fi
_CK4MS_
_2GSU_

# pull.buildAPKs.modules.bash EOF
