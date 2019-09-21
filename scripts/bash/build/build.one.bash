#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by S D Rausty 
# Adapted from https://github.com/fx-adi-lima/android-tutorials
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SBOTRPERROR_() { # run on script error
	local RV="$?"
	echo $RV build.one.bash  
	if [[ "$2" = ecj ]]  
	then 
		mkdir -p "$RDR/tmp"
		if [[ -n $(find "$RDR/tmp" -name "*.err") ]] # https://unix.stackexchange.com/questions/46541/how-can-i-use-bashs-if-test-and-find-commands-together
		then 
			:
		else
			CER="conf.$PPID.err"
			echo "$1 $2 $3 $RV" > "$RDR/tmp/$CER" # https://stackoverflow.com/questions/11162406/open-and-write-data-to-text-file-using-bash-shell-scripting
			printf "\\033[0;34m\\n%s\\033[1;37m\\n\\n%s\\n\\n\033[0m" "Attempting to fix https://github.com/termux/termux-packages/issues?q=is%3Aissue+ecj+error ecj error." "This may take a little while pending connection…"
			printf '\033]2; Please wait moment…  \007'
			sleep 0.64
			if [[ "$(command getprop ro.build.version.sdk)" -gt 26 ]] 
			then
				echo Installing package ecj_4.7.2-1_all.deb...
 				. "$RDR/scripts/bash/tdebs/fix.ecj.error.bash"
				echo "Package ecj_4.7.2-1_all.deb installed; Continuing..."
			else
				echo "Installing package ecj4.6_4.6.2_all.deb..." 
 				. "$RDR/scripts/bash/tdebs/fix.ecj4.6.error.bash"
				echo "Package ecj4.6_4.6.2_all.deb installed; Continuing..."
			fi
		fi
	else
		printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!  More information in \`%s/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "$RV" "$RDR" "$JID" 
	fi
	if [[ "$RV" = 1 ]] 
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mOn Signal 1 try running %s again; This error can be resolved by running %s in a directory that has the \`AndroidManifest.xml\` file.  More information in \`%s/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "${0##*/}" "$RDR" "$JID" 
		ls
	fi
	if [[ "$RV" = 255 ]]
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mOn Signal 255 try running %s again if the error includes R.java and similar; This error might have been corrected by clean up.  More information in \`%s/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "$RDR" "$JID" 
	fi
	_CLEANUP_
	exit 160
}

_SBOTRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs signal %s received by %s in %s by build.one.bash.  More information in \`%s/log/stnderr.%s.log\` file.\\e[0m\\n\\n" "$RV" "${0##*/}" "$PWD" "$RDR" "$JID" 
		echo "Running: tail -n 16 $RDR/log/stnderr.$JID.log"
		echo 
		tail -n 16 "$RDR/log/stnderr.$JID.log"
		printf "\\e[0m\\n\\n" 
	fi
	if [[ "$RV" = 220 ]]  
	then 
		printf "\\n\\n\\e[1;7;38;5;143m	Signal %s generated in %s by %s; Downgrading the version of \`ecj\` is a potential solution if this signal was generated while ecj was compiling.  Version ecj/stable,now 4.7.2-2 does not run very well; This might be solved through sharing here https://github.com/termux/termux-packages/pulls and https://github.com/termux/termux-packages/issues/3157 here.  First comment on Dec 20, 2018\\n\\n	More information about keeping a system as stable as possible by downgrading a package when the want arrises is https://sdrausty.github.io/au here.\\n\\n	\`ecj_4.7.2-1\` works better than the version currently in use, so it is included for convience in \`buildAPKs/debs\`.  Use \`dpkg --purge ecj\` followed by \`dpkg --install ecj_4.7.2-1_all.deb\` to downgrade \`ecj\` to a stable version.\\e[0m\\n\\n" "$RV" "$PWD" "${0##*/}" 
		sleep 4
	fi
	if [[ "$RV" = 223 ]]  
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mSignal 223 generated in %s; Try running %s again; This error can be resolved by running %s in a directory that has an \`AndroidManifest.xml\` file.  More information in \`stnderr*.log\` files.\\n\\nRunning \`ls\`:\\e[0m\\n" "$PWD" "${0##*/}" "${0##*/}"
		ls
	fi
	if [[ "$RV" = 224 ]]  
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mSignal 224 generated in %s;  Cannot run in $HOME!  See \`stnderr*.log\` file.\\n\\nRunning \`ls\`:\\e[0m\\n" "$PWD" "${0##*/}" "${0##*/}"
	fi
	_CLEANUP_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SBOTRPSIGNAL_() { # run on signal
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received by build.one.bash!\\e[0m\\n" "${0##*/}" "$?" 
 	exit 161 
}

_SBOTRPQUIT_() { # run on quit
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received by build.one.bash!\\e[0m\\n" "${0##*/}" "$?"
 	exit 162 
}

trap '_SBOTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SBOTRPEXIT_ EXIT
trap _SBOTRPSIGNAL_ HUP INT TERM 
trap _SBOTRPQUIT_ QUIT 

_CLEANUP_ () {
	sleep 0.32 
	printf "\\e[1;38;5;151m%s\\n\\e[0m" "Cleaning up..."
	rm -f *-debug.key 
 	rm -rf ./bin 
	rm -rf ./gen 
 	rm -rf ./obj 
	find . -name R.java -exec rm {} \; ||: 
	printf "\\e[1;38;5;151mCompleted tasks in ~/%s/.\\n\\n\\e[0m" "${PWD:33}"
}

NOW=$(date +%s)
PKGNAM="$(grep -o "package=.*" AndroidManifest.xml | cut -d\" -f2)"
PKGNAME="$PKGNAM.$NOW"
if [[ -z "${DAY:-}" ]] 
then
	DAY="$(date +%Y%m%d)"
fi
if [[ -z "${RDR:-}" ]] 
then
	RDR="${PWD##*/}" # https://stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-a-bash-script
fi
if [[ -z "${1:-}" ]] 
then
	export EXT=""
else
	export EXT="$1"
fi
if [[ -z "${2:-}" ]] 
then
	JDR="$PWD"
else
	JDR="$2"
fi
if [[ -z "${JID:-}" ]] 
then
	JID="${PWD##*/}" # https://www.tldp.org/LDP/abs/html/parameter-substitution.html 
fi
if [[ -z "${NUM:-}" ]] 
then
	NUM=""
fi
if [[ "$PWD" = "$HOME" ]] 
then
	echo "Cannot run in $HOME!  Signal 224 generated in $PWD."
	exit 224
fi
printf "\\e[0m\\n\\e[1;38;5;116mBeginning build in ~/%s/...\\n\\e[0m" "${PWD:33}"
if [[ ! -e "./assets" ]]
then
	mkdir -p ./assets
fi
if [[ ! -d "./bin" ]]
then
	mkdir -p ./bin
fi
if [[ ! -d "./gen" ]]
then
	mkdir -p ./gen
fi
if [[ ! -d "./obj" ]]
then
	mkdir -p ./obj
fi
if [[ ! -d "./res" ]]
then
	mkdir -p ./res
fi
printf "\\e[1;38;5;115m%s\\n\\e[0m" "aapt: started..."
aapt package -f \
	-M AndroidManifest.xml \
	-J gen \
	-S res 
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;114m%s\\n\\e[0m" "aapt: done" "ecj: begun..."
ecj -d ./obj -sourcepath . $(find . -type f -name "*.java")
printf "\\e[1;38;5;149m%s;  \\e[1;38;5;113m%s\\n\\e[0m" "ecj: done" "dx: started..."
dx --dex --output=bin/classes.dex obj
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;112m%s\\n\\e[0m" "dx: done" "Making $PKGNAM.apk..."
aapt package -f \
	--min-sdk-version 1 \
	--target-sdk-version 23 \
	-M AndroidManifest.xml \
	-S res \
	-A assets \
	-F bin/"$PKGNAM.apk"
printf "\\e[1;38;5;113m%s\\e[1;38;5;107m\\n" "Adding classes.dex to $PKGNAM.apk..."
cd bin 
aapt add -f "$PKGNAM.apk" classes.dex
printf "\\e[1;38;5;114m%s\\e[1;38;5;108m\\n" "Signing $PKGNAM.apk..."
apksigner ../"$PKGNAM-debug.key" "$PKGNAM.apk" ../"$PKGNAM.apk"
cd ..
if [[ -w "/storage/emulated/0/" ]] 
then
	if [[ ! -d "/storage/emulated/0/Download/builtAPKs/$JID$DAY" ]]
	then
		mkdir -p "/storage/emulated/0/Download/builtAPKs/$JID$DAY"
	fi
	cp "$PKGNAM.apk" "/storage/emulated/0/Download/builtAPKs/$EXT$DAY/$PKGNAME.apk"
	printf "\\e[1;38;5;115mCopied %s to Download/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$EXT$DAY" "$PKGNAME"
	printf "\\e[1;38;5;149mThe APK %s file can be installed from Download/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$EXT$DAY" "$PKGNAME"
else
	if [[ ! -d "$RDR/cache/builtAPKs/$JID$DAY" ]]
	then
		mkdir -p "$RDR/cache/builtAPKs/$JID$DAY"
	fi
	cp "$PKGNAM.apk" "$RDR/cache/builtAPKs/$EXT$DAY/$PKGNAME.apk"
	printf "\\e[1;38;5;120mCopied %s to ~/${RDR:33}/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$EXT$DAY" "$PKGNAME"
	printf "\\e[1;38;5;154mThe APK %s file can be installed from ~/${RDR:33}/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$EXT$DAY" "$PKGNAME"
fi
printf "\\e[?25h\\e[1;7;38;5;34mShare %s everwhere%s!\\e[0m\\n" "https://wiki.termux.com/wiki/Development" "🌎🌍🌏🌐"

#build.one.bash EOF
