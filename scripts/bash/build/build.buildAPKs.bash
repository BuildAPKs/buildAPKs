#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by BuildAPKs https://BuildAPKs.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SETRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
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
 	exit 211 
}

_SETRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SETRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SETRPEXIT_ EXIT
trap _SETRPSIGNAL_ HUP INT TERM 
trap _SETRPQUIT_ QUIT 

export RDR="$HOME/buildAPKs"
export SDR="/scripts/bash/build"
declare -a LIST # declare array for all build scripts 
LIST=("$RDR$SDR/build.apps.bash" "$RDR$SDR/build.clocks.bash" "$RDR$SDR/build.compasses.bash" "$RDR$SDR/build.developers.tools.bash" "$RDR$SDR/build.entertainment.bash" "$RDR$SDR/build.flashlights.bash" "$RDR$SDR/build.games.bash" "$RDR$SDR/build.live.wallpapers.bash" "$RDR$SDR/build.samples.bash" "$RDR$SDR/buildApplications.bash" "$RDR$SDR/buildBrowsers.bash" "$RDR$SDR/buildFlashlights.bash" "$RDR$SDR/buildGames.bash" "$RDR$SDR/buildSamples.bash" "$RDR$SDR/buildTop10.bash" "$RDR$SDR/buildTutorials.bash" "$RDR$SDR/buildWidgets.bash" "$RDR$SDR/buildAll.bash")
for NAME in "${LIST[@]}"
do
	if [[ "$NAME" == "$RDR$SDR/buildAll.bash" ]]
	then
		find "$RDR" -type f -name .git -delete
		"$NAME"
	else
		"$NAME"
	fi
done
# build.buildAPKs.bash EOF
