#!/bin/env bash
# Copyright 2019 (c) all rights reserved 
# by BuildAPKs https://buildapks.github.io/buildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SPREPTRPERROR_() { # run on script error
	local RV="$?"
	echo "$RV" prep.bash
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 144
}

_SPREPTRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SPREPTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "prep.bash" "$RV"
 	exit 145 
}

_SPREPTRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "prep.bash" "$RV"
 	exit 146 
}

trap '_SPREPTRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SPREPTRPEXIT_ EXIT
trap _SPREPTRPSIGNAL_ HUP INT TERM 
trap _SPREPTRPQUIT_ QUIT 

declare -A ADM	# declare associative array for all for all superfluous files
ADM=([Android.kpf]=Android.kpf [axel]=axel [curl]=curl [lftp]=lftpget [wget]=wget)

_AF_ () { # finds and removes superfluous files
	for name in "${!ADM[@]}" 
	do
		find . -type f -name "$name" -exec rm -f {} \;
	done
}

_AF_ 
find . -type f 

find . -type f -name Android.kpf -exec rm -f {} \;
find . -type f -name ant.properties -exec rm -f {} \;
find . -type f -name '*.apk' -exec rm -f {} \;
find . -type f -name build.xml -exec rm -f {} \;
find . -type f -name .classpath -exec rm -f {} \;
find . -type f -name default.properties -exec rm -f {} \;
find . -type f -name gradle-wrapper.jar -exec rm -f {} \;
find . -type f -name gradle-wrapper.properties -exec rm -f {} \;
find . -type f -name 'local.properties' -exec rm -f {} \;
find . -type f -name makefile -exec rm -f {} \;
find . -type f -name makefile.linux_pc -exec rm -f {} \;
find . -type f -name pom.xml -exec rm -f {} \;
find . -type f -name proguard.cfg -exec rm -f {} \;
find . -type f -name proguard-project.txt -exec rm -f {} \;
find . -type f -name .project -exec rm -f {} \;
find . -type f -name project.properties -exec rm -f {} \;
find . -type f -name R.java -exec rm -f {} \;
find . -type f -name .settings -exec rm -f {} \;

#EOF
