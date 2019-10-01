#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by BuildAPKs https://BuildAPKs.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SETRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 201
	exit 201
}

_SETRPEXIT_() { # Run on exi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SETRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 211
 	exit 211 
}

_SETRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	echo exit 221
 	exit 221 
}

trap '_SETRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SETRPEXIT_ EXIT
trap _SETRPSIGNAL_ HUP INT TERM 
trap _SETRPQUIT_ QUIT 

export RDR="$HOME/buildAPKs"
declare -a LIST # declare array for all superfluous files
LIST=("$RDR/scripts/bash/build/build.apps.bash" "$RDR/scripts/bash/build/build.clocks.bash" "$RDR/scripts/bash/build/build.compasses.bash" "$RDR/scripts/bash/build/build.developers.tools.bash" "$RDR/scripts/bash/build/build.entertainment.bash" "$RDR/scripts/bash/build/build.flashlights.bash" "$RDR/scripts/bash/build/build.games.bash" "$RDR/scripts/bash/build/build.live.wallpapers.bash" "$RDR/scripts/bash/build/build.samples.bash" "$RDR/scripts/bash/build/buildApplications.bash" "$RDR/scripts/bash/build/buildBrowsers.bash" "$RDR/scripts/bash/build/buildFlashlights.bash" "$RDR/scripts/bash/build/buildGames.bash" "$RDR/scripts/bash/build/buildSamples.bash" "$RDR/scripts/bash/build/buildTop10.bash" "$RDR/scripts/bash/build/buildTutorials.bash" "$RDR/scripts/bash/build/buildWidgets.bash" "$RDR/scripts/bash/build/buildAll.bash")
for NAME in "${LIST[@]}"
do
	"$NAME"
done

# build.buildAPKs.bash EOF
