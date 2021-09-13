#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved by BuildAPKs
# See LICENSE for details https://buildapks.github.io/docsBuildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
[ -z "${RDR:-}" ] && RDR="$HOME/buildAPKs"
[ "$PWD" = "${PREFIX%/*}" ] || [ "$PWD" = "$PREFIX" ] || [ "$PWD" = "$HOME" ] || [ "$PWD" = "$RDR" ] && { printf "Signal 224 generated in %s;  Command '${0##*/}' cannot be run in directory %s; %s exiting...\\n" "$PWD" "$PWD" "${0##*/} build.one.bash" ; exit 224 ; }

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
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && [ "$RV" != 0 ] && [ "$RV" != 224 ] && printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs signal %s received by %s in %s by build.one.bash.  More information in \`%s/var/log/stnderr.%s.log\` file.\\n\\n" "$RV" "${0##*/}" "$PWD" "$RDR" "$JID" && (printf "%s\\e[0m\\n" "Running: VAR=\"\$(grep -C 2 -ie error -ie errors \"$RDR/var/log/stnderr.$JID.log\")\" && VAR=\"\$(grep -v \\-\\- <<< \$VAR)\" && head <<< \$VAR && tail <<< \$VAR ") && VAR="$(grep -C 2 -ie error -ie errors "$RDR/var/log/stnderr.$JID.log")" && VAR="$(grep -v \\-\\- <<< "$VAR")" && head <<< "$VAR" && tail <<< "$VAR" && printf "\\n\\n"
	[[ $(awk 'NR==1' "$RDR/.conf/QUIET") == false ]] && [ "$RV" = 223 ] && printf "\\e[?25h\\e[1;7;38;5;0mSignal 223 generated in %s; Try running %s again; This error can be resolved by running %s in a directory that has an \`AndroidManifest.xml\` file.  More information in \`stnderr*.log\` files.\\n\\nRunning \`ls\`:\\e[0m\\n" "$PWD" "${0##*/}" "${0##*/}" && ls
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
	rm -f ./*-debug.key
 	rm -rf ./output ./gen ./obj
	[ -d ./assets ] && rmdir --ignore-fail-on-non-empty ./assets
	[ -d ./res ] && rmdir --ignore-fail-on-non-empty ./res
	find . -type f -name "*.class" -delete
	find . -type f -name R.java -delete
	printf "\\e[1;38;5;151mCompleted tasks in ~/%s/.\\n\\n\\e[0m" "$(cut -d"/" -f7-99 <<< "$PWD")"
}

_PRINTSGE_ () {
	printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal generated $1 ${0##*/} build.one.bash: EXITING..."
	exit 220
}

# if root directory is undefined, define the root directory as ~/buildAPKs
. "$RDR"/scripts/bash/shlibs/buildAPKs/copy.apk.bash
# if working directory is $HOME or buildAPKs, exit
printf "\\e[0m\\n\\e[1;38;5;116mBeginning build in ~/%s/:\\n\\e[0m" "$(cut -d"/" -f7-99 <<< "$PWD")"
# if variables are undefined, define variables
find . -maxdepth 1 -type f -name "*.apk" -delete
find . -type f -print | sed 's@.*/@@' | sort
[ -z "${DAY:-}" ] && DAY="$(date +%Y%m%d)"
[ -z "${2:-}" ] && JDR="$PWD"
[ -z "${JID:-}" ] && JID="${PWD##*/}" # https://www.tldp.org/LDP/abs/html/parameter-substitution.html
[ -z "${NUM:-}" ] && NUM=""
# if it does not exist, create it
[ -e ./assets ] || mkdir -p ./assets
[ -e ./output/lib ] || mkdir -p ./output/lib
[ -e ./gen ] || mkdir -p ./gen
[ -e ./obj ] || mkdir -p ./obj
[ -e ./res ] || mkdir -p ./res
LIBAU="$(awk 'NR==1' "$RDR/.conf/LIBAUTH")" # load true/false from .conf/LIBAUTH file.  File LIBAUTH has information about loading artifacts and libraries into the build process.
if [[ "$LIBAU" == true ]]
then # load artifacts and libraries into the build process
	printf "\\e[1;34m%s" "Loading artifacts and libraries into the compilation:  "
	BOOTCLASSPATH=""
	SYSJCLASSPATH=""
	JSJCLASSPATH=""
	DIRLIST=""
	LIBDIRPATH=("$JDR/lib" "$JDR/libraries" "$JDR/library" "$JDR/libs" "$RDR/var/cache/lib") # modify array LIBDIRPATH to suit the projects artifact needs.
	for LIBDIR in ${LIBDIRPATH[@]} # every element in array LIBDIRPATH
	do	# directory path check
	 	if [[ -d "$LIBDIR" ]] # library directory exists
		then	# search directory for artifacts and libraries
			DIRLIS="$(find -L "$LIBDIR" -type f -name "*.jar" 2>/dev/null)" || _PRINTSGE_ DIRLIS
			DIRLIST="$DIRLIST $DIRLIS"
			NUMIA=$(wc -l <<< "$DIRLIST")
	 		if [[ $DIRLIS == "" ]] # nothing was found
			then	# adjust ` wc -l ` count to zero
				NUMIA=0
			fi
			printf "\\e[1;34m%s" "Adding $NUMIA artifacts and libraries from directory $LIBDIR into build ${PWD##*/} : "
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
 	ECJENT=" -cp $BOOTCLASSPATH "
	printf "\\e[1;32m\\bDONE\\e[0m\\n"
else # do not load artifacts and libraries into the build process.
 	AAPTENT=""
 	ECJENT=""
	JSJCLASSPATH=""
fi
NOW=$(date +%s)
PKGNAM="$(grep -o "package=.*" AndroidManifest.xml | cut -d\" -f2)"
[ -f ./output/"$PKGNAM.apk"  ] && rm ./output/"$PKGNAM.apk"
PKGNAME="$PKGNAM.$NOW"
COMMANDIF="$(command -v getprop)" ||:
if [[ "$COMMANDIF" = "" ]]
then
	MSDKVERSION="14"
 	PRSYSLOCALE="en"
	TSDKVERSION="23"
else
	MSDKVERSION="$(getprop ro.build.version.min_supported_target_sdk)" || printf "%s" "signal ro.build.version.min_supported_target_sdk ${0##*/} build.one.bash generated; Continuing...  " && MSDKVERSION="14"
 	PRSYSLOCALE="$(getprop persist.sys.locale|awk -F- '{print $1}')" || printf "%s" "Signal persist.sys.locale ${0##*/} build.one.bash generated; Continuing...  " && PRSYSLOCALE="en"
	TSDKVERSION="$(getprop ro.build.version.sdk)" || printf "%s" "Signal ro.build.version.sdk ${0##*/} build.one.bash generated; Continuing...  " && TSDKVERSION="23"
fi
sed -i "s/minSdkVersion\=\"[0-9]\"/minSdkVersion\=\"$MSDKVERSION\"/g" AndroidManifest.xml
sed -i "s/minSdkVersion\=\"[0-9][0-9]\"/minSdkVersion\=\"$MSDKVERSION\"/g" AndroidManifest.xml
sed -i "s/targetSdkVersion\=\"[0-9]\"/targetSdkVersion\=\"$TSDKVERSION\"/g" AndroidManifest.xml
sed -i "s/targetSdkVersion\=\"[0-9][0-9]\"/targetSdkVersion\=\"$TSDKVERSION\"/g" AndroidManifest.xml
printf "\\e[1;38;5;115m%s\\n\\e[0m" "aapt: started..."
# build entry point
aapt package $AAPTENT -c "$PRSYSLOCALE" -f --generate-dependencies -J gen --min-sdk-version "$MSDKVERSION" -M AndroidManifest.xml --target-sdk-version "$TSDKVERSION" --replace-version -S res --version-code "$NOW" --version-name "$PKGNAME" || _PRINTSGE_ aapt
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;114m%s\\n\\e[0m" "aapt: done" "dalvikvm: begun..."
unset JAVA_HOME
dalvikvm -Xmx512m -Xcompiler-option --compiler-filter=speed -cp "$PREFIX"/share/dex/ecj.jar org.eclipse.jdt.internal.compiler.batch.Main -proc:none -source 1.8 -target 1.8 -cp "$PREFIX"/share/java/android.jar $ECJENT -d ./obj . || _PRINTSGE_ dalvikvm
printf "\\e[1;38;5;149m%s;  \\e[1;38;5;113m%s\\n\\e[0m" "dalvikvm: done" "dx: started..."
dx --dex --output=output/classes.dex ./obj || _PRINTSGE_ dx
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;112m%s\\n\\e[0m" "dx: done" "Making $PKGNAME.apk..."
aapt package -f --min-sdk-version "$MSDKVERSION" --target-sdk-version "$TSDKVERSION" -M AndroidManifest.xml $JSJCLASSPATH -S ./res -A ./assets -F ./output/"$PKGNAME".apk || _PRINTSGE_ aapt
cd output
ISDOSO="$(head -n 1 "$RDR/.conf/DOSO")"
if [[ $ISDOSO = 0 ]]
then
	. "$RDR"/scripts/bash/shlibs/buildAPKs/doso.bash || printf "\\e[1;48;5;166m%s\\e[0m\\n" "Signal generated doso.bash ${0##*/} build.one.bash: Continuing..."
	cd "$JDR"
 	. "$RDR"/scripts/bash/shlibs/buildAPKs/native.bash || printf "\\e[1;48;5;166m%s\\e[0m\\n" "Signal generated native.bash ${0##*/} build.one.bash: Continuing..."
 	cd "$JDR"/output
else
	printf "%s\\n" "To build and include \`*.so\` files in the APK build change the 1 in file ~/${RDR##*/}/.conf/DOSO to a 0.  The command \`build.native.bash\` builds native APKs on device and will do this when run."
fi
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
printf "\\e[1;38;5;116mThe built APK can be installed with the command:  termux-open ~/%s/%s  \\n" "$(cut -d"/" -f7-99 <<< "$PWD")" "$PKGNAM.apk"
printf "\\e[1;7;38;5;34mPlease share %s everwhere%s!\\e[0m\\n" "https://wiki.termux.com/wiki/Development" "🌎🌍🌏🌐"
# build.one.bash EOF
