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

cd "$HOME/buildAPKs/"
./scripts/bash/build/build.apps.bash
./scripts/bash/build/build.clocks.bash
./scripts/bash/build/build.compasses.bash
./scripts/bash/build/build.developers.tools.bash
./scripts/bash/build/build.entertainment.bash
./scripts/bash/build/build.flashlights.bash
./scripts/bash/build/build.games.bash
./scripts/bash/build/build.live.wallpapers.bash
./scripts/bash/build/build.samples.bash
./scripts/bash/build/buildApplications.bash
./scripts/bash/build/buildBrowsers.bash
./scripts/bash/build/buildFlashlights.bash
./scripts/bash/build/buildGames.bash
./scripts/bash/build/buildSamples.bash
./scripts/bash/build/buildTop10.bash
./scripts/bash/build/buildTutorials.bash
./scripts/bash/build/buildWidgets.bash
./scripts/bash/build/buildAll.bash

# build.buildAPKs.bash EOF
