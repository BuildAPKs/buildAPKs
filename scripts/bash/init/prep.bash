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

_AFR_ () { # finds and removes superfluous files
	printf "\\n%s\\n" "Preparing directory $JDR/$SFX"
	for NAME in "${DLIST[@]}" 
	do
 		find "$JDR/$SFX" -type d -name "$NAME" -exec rm -rf {} \; 2>/dev/null
	done
	for NAME in "${FLIST[@]}" 
	do
 		find "$JDR/$SFX" -type f -name "$NAME" -delete
	done
	find  "$JDR/$SFX" -type d -empty -delete
}

declare -a DLIST # declare array for all superfluous directories
declare -a FLIST # declare array for all superfluous files
DLIST=(".idea" "gradle")
FLIST=("*.apk"  "*.aar" "*.jar" ".gitignore" "Android.kpf" "ant.properties" "build.gradle" "build.xml" ".classpath" "default.properties" "gradle-wrapper.properties" "gradlew" "gradlew.bat" "gradle.properties" "gradle.xml" "lint.xml" "local.properties" "makefile" "makefile.linux_pc" "org.eclipse.jdt.core.prefs" "pom.xml" "proguard.cfg" "proguard-project.txt" ".project" "project.properties" "R.java" ".settings" "settings.gradle" "WebRTCSample.iml")

# prep.bash EOF
