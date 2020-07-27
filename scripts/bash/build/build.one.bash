#!/usr/bin/env bash
# Copyright 2017-2020 (c) all rights reserved by S D Rausty 
# Adapted from https://github.com/fx-adi-lima/android-tutorials
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SBOTRPERROR_() { # run on script error
	local RV="$?"
	printf "buildAPKs %s WARNING:  ERROR %s received by build.one.bash!\n" "${0##*/}" "$RV" 
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s build.one.bash ERROR:  Signal %s received!  More information in \`%s/var/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "$RV" "$RDR" "$JID" 
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && [ "$RV" = 255 ] && printf "\\e[?25h\\e[1;7;38;5;0mOn Signal 255 try running %s again if the error includes R.java and similar; This error might have been corrected by clean up.  More information in \`%s/var/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "$RDR" "$JID" 
 	_CLEANUP_
	exit 160
}

_SBOTRPEXIT_() { # run on exit
	local RV="$?"
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && [ "$RV" != 0 ] && [ "$RV" != 224 ] && printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs signal %s received by %s in %s by build.one.bash.  More information in \`%s/var/log/stnderr.%s.log\` file.\\n\\n" "$RV" "${0##*/}" "$PWD" "$RDR" "$JID" && (printf "%s\\e[0m\\n" "Running: VAR=\"\$(grep -C 2 -ie error -ie errors \"$RDR/var/log/stnderr.$JID.log\")\" && VAR=\"\$(grep -v \\-\\- <<< \$VAR)\" && head <<< \$VAR && tail <<< \$VAR ") && VAR="$(grep -C 2 -ie error -ie errors "$RDR/var/log/stnderr.$JID.log")" && VAR="$(grep -v \\-\\- <<< $VAR)" && head <<< $VAR && tail <<< $VAR && printf "\\n\\n" 
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && [ "$RV" = 223 ] && printf "\\e[?25h\\e[1;7;38;5;0mSignal 223 generated in %s; Try running %s again; This error can be resolved by running %s in a directory that has an \`AndroidManifest.xml\` file.  More information in \`stnderr*.log\` files.\\n\\nRunning \`ls\`:\\e[0m\\n" "$PWD" "${0##*/}" "${0##*/}" && ls
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && [ "$RV" = 224 ] && printf "\\e[?25h\\e[1;7;38;5;0mSignal 224 generated in %s;  Cannot run in folder %s; %s exiting...\\e[0m\\n" "$PWD" "$PWD" "${0##*/} build.one.bash"
 	_CLEANUP_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SBOTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "buildAPKs %s WARNING:  SIGNAL %s received by build.one.bash!\n" "${0##*/}" "$RV" 
 	_CLEANUP_
 	exit 161 
}

_SBOTRPQUIT_() { # run on quit
	local RV="$?"
	printf "buildAPKs %s WARNING:  QUIT SIGNAL %s received by build.one.bash!\n" "${0##*/}" "$RV"
 	_CLEANUP_
 	exit 162 
}

trap '_SBOTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SBOTRPEXIT_ EXIT
trap _SBOTRPSIGNAL_ HUP INT TERM 
trap _SBOTRPQUIT_ QUIT 

_CLEANUP_ () {
	sleep 0."$(shuf -i 24-72 -n 1)" # add device latency support 
	printf "\\e[1;38;5;151m%s\\n\\e[0m" "Completing tasks..."
	rm -f *-debug.key 
 	rm -rf ./bin ./gen ./obj 
	[ -d ./assets ] && rmdir --ignore-fail-on-non-empty ./assets
	[ -d ./res ] && rmdir --ignore-fail-on-non-empty ./res
	find . -name R.java -exec rm -f { } \;
	printf "\\e[1;38;5;151mCompleted tasks in ~/%s/.\\n\\n\\e[0m" "$(cut -d"/" -f7-99 <<< $PWD)"
}
# if root directory is undefined, define the root directory as ~/buildAPKs 
[ -z "${RDR:-}" ] && RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/shlibs/buildAPKs/copy.apk.bash
# if working directory is $HOME or buildAPKs, exit 
[ "$PWD" = "$HOME" ] || [ "${PWD##*/}" = buildAPKs ] && exit 224
printf "\\e[0m\\n\\e[1;38;5;116mBeginning build in ~/%s/:\\n\\e[0m" "$(cut -d"/" -f7-99 <<< $PWD)"
# if variables are undefined, define variables
[ -z "${DAY:-}" ] && DAY="$(date +%Y%m%d)"
[ -z "${2:-}" ] && JDR="$PWD"
[ -z "${JID:-}" ] && JID="${PWD##*/}" # https://www.tldp.org/LDP/abs/html/parameter-substitution.html 
[ -z "${NUM:-}" ] && NUM=""
# if it does not exist, create it 
[ ! -e "./assets" ] && mkdir -p ./assets
[ ! -e "./bin" ] && mkdir -p ./bin
[ ! -e "./gen" ] && mkdir -p ./gen
[ ! -e "./obj" ] && mkdir -p ./obj
[ ! -e "./res" ] && mkdir -p ./res
LIBAU="$(awk 'NR==1' "$RDR/.conf/LIBAUTH")" # load true/false from .conf/LIBAUTH file.  File LIBAUTH has information about loading artifacts and libraries into the build process. 
if [[ "$LIBAU" == true ]]
then # load artifacts and libraries into the build process
	printf "\\e[1;34m%s" "Loading artifacts and libraries into the compilation:  "
	BOOTCLASSPATH=""
	SYSJCLASSPATH=""
	JSJCLASSPATH=""
	DIRLIST=""
	LIBDIRPATH=("$JDR/../../../lib" "$JDR/../../../libraries" "$JDR/../../../library" "$JDR/../../../libs" "$JDR/../../lib" "$JDR/../../libraries" "$JDR/../../library" "$JDR/../../libs" "$JDR/../lib" "$JDR/../libraries" "$JDR/../library" "$JDR/../libs" "$JDR/lib" "$JDR/libraries" "$JDR/library" "$JDR/libs" "$RDR/var/cache/lib" "/system") # modify array LIBDIRPATH to suit the projects artifact needs.  
	for LIBDIR in ${LIBDIRPATH[@]} # every element in array LIBDIRPATH 
	do	# directory path check
	 	if [[ -d "$LIBDIR" ]] # library directory exists
		then	# search directory for artifacts and libraries
			DIRLIS="$(find -L "$LIBDIR" -type f -name "*.aar" -or -type f -name "*.jar" -or -type f -name "*.vdex" 2>/dev/null)"||:
			DIRLIST="$DIRLIST $DIRLIS"
			NUMIA=$(wc -l <<< $DIRLIST)
	 		if [[ $DIRLIS == "" ]] # nothing was found 
			then	# adjust ` wc -l ` count to zero
				NUMIA=0
			fi
			printf "\\e[1;34m%s" "Adding $NUMIA artifacts and libraries from directory "$LIBDIR" into build "${PWD##*/}":  "
		fi
	done
	for LIB in $DIRLIST
	do
		BOOTCLASSPATH=${LIB}:${BOOTCLASSPATH};
		SYSJCLASSPATH="-I $LIB $SYSJCLASSPATH"
		JSJCLASSPATH="-j $LIB $SYSJCLASSPATH"
	done
	BOOTCLASSPATH=${BOOTCLASSPATH%%:}
 	AAPTENT=" $SYSJCLASSPATH " 
	[ -e "./libs/res-appcompat" ] && AAPTENT=" -S libs/res-appcompat $AAPTENT"
	[ -e "./libs/res-cardview" ] && AAPTENT=" -S libs/res-cardview $AAPTENT"
	[ -e "./libs/res-design" ] && AAPTENT=" -S libs/res-design $AAPTENT"
	[ -e "./libs/res-recyclerview" ] && AAPTENT=" -S libs/res-recyclerview $AAPTENT"
 	AAPTENT=" --auto-add-overlay $SYSJCLASSPATH " # add 500K 
 	ECJENT=" -classpath $BOOTCLASSPATH "
	printf "\\e[1;32m\\bDONE\\e[0m\\n"
else # do not load artifacts and libraries into the build process.
 	AAPTENT=""
 	ECJENT=""
	JSJCLASSPATH=""
fi
NOW=$(date +%s)
PKGNAM="$(grep -o "package=.*" AndroidManifest.xml | cut -d\" -f2)"
[ -f ./bin/"$PKGNAM.apk"  ] && rm ./bin/"$PKGNAM.apk" 
PKGNAME="$PKGNAM.$NOW"
COMMANDIF="$(command -v getprop)" ||:
if [[ "$COMMANDIF" = "" ]]
then
	MSDKVERSION="14"
 	PSYSLOCAL="en"
	TSDKVERSION="23"
else
	MSDKVERSION="$(getprop ro.build.version.min_supported_target_sdk)" || printf "%s" "signal ro.build.version.min_supported_target_sdk ${0##*/} build.one.bash generated; Continuing...  " && MSDKVERSION="14"
 	PSYSLOCAL="$(getprop persist.sys.locale|awk -F- '{print $1}')" || printf "%s" "Signal persist.sys.locale ${0##*/} build.one.bash generated; Continuing...  " && PSYSLOCAL="en"
	TSDKVERSION="$(getprop ro.build.version.sdk)" || printf "%s" "Signal ro.build.version.sdk ${0##*/} build.one.bash generated; Continuing...  " && TSDKVERSION="23"
fi
sed -i "s/minSdkVersion\=\"[0-9]\"/minSdkVersion\=\"$MSDKVERSION\"/g" AndroidManifest.xml 
sed -i "s/minSdkVersion\=\"[0-9][0-9]\"/minSdkVersion\=\"$MSDKVERSION\"/g" AndroidManifest.xml 
sed -i "s/targetSdkVersion\=\"[0-9]\"/targetSdkVersion\=\"$TSDKVERSION\"/g" AndroidManifest.xml 
sed -i "s/targetSdkVersion\=\"[0-9][0-9]\"/targetSdkVersion\=\"$TSDKVERSION\"/g" AndroidManifest.xml 
printf "\\e[1;38;5;115m%s\\n\\e[0m" "aapt: started..."
aapt package -f \
 	--min-sdk-version "$MSDKVERSION" --target-sdk-version "$TSDKVERSION" --version-code "$NOW" --version-name "$PKGNAME" -c "$PSYSLOCAL" \
	-M AndroidManifest.xml \
 	$AAPTENT \
	-J gen \
	-S res
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;114m%s\\n\\e[0m" "aapt: done" "ecj: begun..."
[[ $(head -n 1 "$RDR/.conf/DOSO") = 1 ]] && printf "%s\\n" "To build and include \`*.so\` files in the APK build change the 1 in file ~/${RDR##*/}/.conf/DOSO to a 0."
[[ $(head -n 1 "$RDR/.conf/DOSO") = 0 ]] && (. "$RDR"/scripts/bash/shlibs/buildAPKs/doso.bash || printf "\\e[1;48;5;166m%s\\e[0m\\n" "Signal generated doso.bash ${0##*/} build.one.bash. ")
# [[ -d "$JDR/bin/lib/$CPUABI" ]] && ECJSO=" -classpath $JDR/bin/lib/$CPUABI" || ECJSO="" # https://www.eclipse.org/forums/index.php/t/94766/
[[ -d ./bin/lib ]] && ECJSO="$(find ./bin/lib -type f -name "*.so")" ||:
if [[ -z "${ECJSO:-}" ]] # is undefined
then # no files found
	ECJSO=""
else # populate ecj .so files string
	ECJSO=" -classpath $ECJSO "
fi
ecj $ECJENT $ECJSO -d ./obj -sourcepath . $(find $JDR -type f -name "*.java") || ecj $ECJENT $ECJSO -d ./obj -sourcepath $(find $JDR -type f -name "*.java") || ( printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal generated ecj ${0##*/} build.one.bash." && exit 167 )
printf "\\e[1;38;5;149m%s;  \\e[1;38;5;113m%s\\n\\e[0m" "ecj: done" "dx: started..."
dx --dex --output=bin/classes.dex obj
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;112m%s\\n\\e[0m" "dx: done" "Making $PKGNAME.apk..."
aapt package -f \
 	--min-sdk-version "$MSDKVERSION" \
	--target-sdk-version "$TSDKVERSION" \
	-M AndroidManifest.xml \
 	$JSJCLASSPATH \
	-S res \
	-A assets \
	-F bin/"$PKGNAME".apk 
cd bin 
[[ ! -d lib ]] && mkdir -p lib 
printf "\\e[1;38;5;113m%s\\e[1;38;5;107m\\n" "Adding classes.dex $(find lib -type f -name "*.so") to $PKGNAME.apk..."
aapt add -v -f "$PKGNAME.apk" classes.dex $(find lib -type f -name "*.so") 
printf "\\e[1;38;5;114m%s" "Signing $PKGNAME.apk: "
apksigner sign --cert "$RDR/opt/key/certificate.pem" --key "$RDR/opt/key/key.pk8" "$PKGNAME.apk" 
printf "%s\\e[1;38;5;108m\\n" "DONE"
printf "\\e[1;38;5;114m%s\\e[1;38;5;108m\\n" "Verifying $PKGNAME.apk..."
apksigner verify --verbose "$PKGNAME.apk" 
_COPYAPK_ || printf "%s\\n" "Unable to copy APK file ${0##*/} build.one.bash; Continuing..." 
mv "$PKGNAME.apk" ../"$PKGNAM.apk"
cd ..
printf "\\e[?25h\\e[1;7;38;5;34mShare %s everwhere%s!\\e[0m\\n" "https://wiki.termux.com/wiki/Development" "🌎🌍🌏🌐"
# build.one.bash EOF
