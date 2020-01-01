#!/usr/bin/env bash
# Copyright 2017-2019 (c) all rights reserved by S D Rausty 
# Adapted from https://github.com/fx-adi-lima/android-tutorials
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SBOTRPERROR_() { # run on script error
	local RV="$?"
	echo $RV build.one.bash  
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s build.one.bash ERROR:  Signal %s received!  More information in \`%s/var/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "$RV" "$RDR" "$JID" 
	if [[ "$RV" = 255 ]]
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mOn Signal 255 try running %s again if the error includes R.java and similar; This error might have been corrected by clean up.  More information in \`%s/var/log/stnderr.%s.log\` file.\\e[0m\\n" "${0##*/}" "$RDR" "$JID" 
	fi
 	_CLEANUP_
	exit 160
}

_SBOTRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]] &&  [[ "$RV" != 224 ]]  
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs signal %s received by %s in %s by build.one.bash.  More information in \`%s/var/log/stnderr.%s.log\` file.\\n\\n" "$RV" "${0##*/}" "$PWD" "$RDR" "$JID" 
		printf "%s\\n" "Running: grep -iC 4 ERROR $RDR/var/log/stnderr.$JID.log | tail "
		grep -iC 4 ERROR "$RDR/var/log/stnderr.$JID.log" | tail 
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
		printf "\\e[?25h\\e[1;7;38;5;0mSignal 224 generated in %s;  Cannot run in %s; %s exiting...\\e[0m\\n" "$PWD" "$HOME" "${0##*/} build.one.bash"
	fi
	if [[ "$RV" != 224 ]]  
	then 
 		_CLEANUP_
	fi
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
 	_CLEANUP_
 	exit 162 
}

trap '_SBOTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SBOTRPEXIT_ EXIT
trap _SBOTRPSIGNAL_ HUP INT TERM 
trap _SBOTRPQUIT_ QUIT 

_CLEANUP_ () {
	sleep 0.032 
	printf "\\e[1;38;5;151m%s\\n\\e[0m" "Completing tasks..."
	rm -f *-debug.key 
 	rm -rf ./bin 
	rm -rf ./gen 
 	rm -rf ./obj 
	find . -name R.java -exec rm {} \; ||: 
	printf "\\e[1;38;5;151mCompleted tasks in %s\\n\\n\\e[0m" "$PWD"
}

[ -z "${RDR:-}" ] && RDR="$HOME/buildAPKs"
[ "$PWD" = "$HOME" ] && exit 224
printf "\\e[0m\\n\\e[1;38;5;116mBeginning build in %s\\n\\e[0m" "$PWD"
[ -z "${DAY:-}" ] && DAY="$(date +%Y%m%d)"
[ -z "${2:-}" ] && JDR="$PWD"
[ -z "${JID:-}" ] && JID="${PWD##*/}" # https://www.tldp.org/LDP/abs/html/parameter-substitution.html 
[ -z "${NUM:-}" ] && NUM=""
[ ! -e "./assets" ] && mkdir -p ./assets
[ ! -e "./bin" ] && mkdir -p ./bin
[ ! -e "./gen" ] && mkdir -p ./gen
[ ! -e "./obj" ] && mkdir -p ./obj
[ ! -e "./res" ] && mkdir -p ./res
LIBAU="$(cat "$RDR/.conf/LIBAUTH" | awk 'NR==1')" # load true/false from $RDR/.conf/LIBAUTH file, see the LIBAUTH file for more information to enable loading of artifacts and libraries into the build process. 
if [[ "$LIBAU" == true ]]
then # load artifacts and libraries into the build process.
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
 	AAPTENT=" --auto-add-overlay $SYSJCLASSPATH " 
 	ECJENT=" -classpath $BOOTCLASSPATH "
	printf "\\e[1;32m\\bDONE\\e[0m\\n"
else # do not load artifacts and libraries into the build process.
	printf "\\e[3;38;5;26m%s\\e[0m\\n" "File ~/"${RDR##*/}"/.conf/LIBAUTH has information regarding the integration of artifacts and libraries into compilations.  The functionality of this option is being enhanced; and to improve this automation, see https://github.com/BuildAPKs/buildAPKs/issues and pulls."
 	AAPTENT=""
 	ECJENT=""
	JSJCLASSPATH=""
fi
NOW=$(date +%s)
PKGNAM="$(grep -o "package=.*" AndroidManifest.xml | cut -d\" -f2)"
PKGNAME="$PKGNAM.$NOW"
COMMANDIF="$(command -v getprop)" ||:
if [[ "$COMMANDIF" = "" ]]
then
	MSDKVERSION="14"
 	PSYSLOCAL="en"
	TSDKVERSION="23"
else
	MSDKVERSIO="$(getprop ro.build.version.min_supported_target_sdk)" || printf "%s" "signal ro.build.version.min_supported_target_sdk ${0##*/} build.one.bash generated; Continuing...  "
	MSDKVERSION="${MSDKVERSIO:-14}"
 	PSYSLOCAL="$(getprop persist.sys.locale|awk -F- '{print $1}')"
	TSDKVERSIO="$(getprop ro.build.version.sdk)" || printf "%s" "Signal ro.build.version.sdk ${0##*/} build.one.bash generated; Continuing...  "
	TSDKVERSION="${TSDKVERSIO:-23}"
fi
sed -i "s/minSdkVersion\=\"[0-9]\"/minSdkVersion\=\"$MSDKVERSION\"/g" AndroidManifest.xml 
sed -i "s/minSdkVersion\=\"[0-9][0-9]\"/minSdkVersion\=\"$MSDKVERSION\"/g" AndroidManifest.xml 
sed -i "s/targetSdkVersion\=\"[0-9]\"/targetSdkVersion\=\"$TSDKVERSION\"/g" AndroidManifest.xml 
sed -i "s/targetSdkVersion\=\"[0-9][0-9]\"/targetSdkVersion\=\"$TSDKVERSION\"/g" AndroidManifest.xml 
printf "\\e[1;38;5;115m%s\\n\\e[0m" "aapt: started..."
aapt package -f \
 	--min-sdk-version "$MSDKVERSION" --target-sdk-version "$TSDKVERSION" --version-code "$NOW" --version-name "$PKGNAM" -c "$PSYSLOCAL" \
	-M AndroidManifest.xml \
 	$AAPTENT \
	-J gen \
	-S res
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;114m%s\\n\\e[0m" "aapt: done" "ecj: begun..."
ecj $ECJENT -d ./obj -sourcepath . $(find . -type f -name "*.java") 
printf "\\e[1;38;5;149m%s;  \\e[1;38;5;113m%s\\n\\e[0m" "ecj: done" "dx: started..."
dx --dex --output=bin/classes.dex obj
printf "\\e[1;38;5;148m%s;  \\e[1;38;5;112m%s\\n\\e[0m" "dx: done" "Making $PKGNAM.apk..."
aapt package -f \
 	--min-sdk-version "$MSDKVERSION" --target-sdk-version "$TSDKVERSION" \
	-M AndroidManifest.xml \
 	$JSJCLASSPATH \
	-S res \
	-A assets \
	-F bin/"$PKGNAM".apk 
printf "\\e[1;38;5;113m%s\\e[1;38;5;107m\\n" "Adding classes.dex to $PKGNAM.apk..."
cd bin 
aapt add -f "$PKGNAM.apk" classes.dex 
printf "\\e[1;38;5;114m%s\\e[1;38;5;108m\\n" "Signing $PKGNAM.apk..."
apksigner ../"$PKGNAM-debug.key" "$PKGNAM.apk" ../"$PKGNAM.apk"
cd ..
if [[ -w "/storage/emulated/0/" ]] || [[ -w "/storage/emulated/legacy/" ]]
then
	if [[ -w "/storage/emulated/0/" ]]
	then
		[[ ! -d "/storage/emulated/0/Download/builtAPKs/$JID.$DAY" ]] && mkdir -p "/storage/emulated/0/Download/builtAPKs/$JID.$DAY"
		cp "$PKGNAM.apk" "/storage/emulated/0/Download/builtAPKs/$JID.$DAY/$PKGNAME.apk"
	fi
	if [[ -w "/storage/emulated/legacy/" ]]
	then
		[[ ! -d "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY" ]] && mkdir -p "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY"
		cp "$PKGNAM.apk" "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY/$PKGNAME.apk"
	fi
	printf "\\e[1;38;5;115mCopied %s to Download/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
	printf "\\e[1;38;5;149mThe APK %s file can be installed from Download/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
else
	[[ ! -d "$RDR/var/cache/builtAPKs/$JID.$DAY" ]] && mkdir -p "$RDR/var/cache/builtAPKs/$JID.$DAY"
	cp "$PKGNAM.apk" "$RDR/var/cache/builtAPKs/$JID.$DAY/$PKGNAME.apk"
	printf "\\e[1;38;5;120mCopied %s to $RDR/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
	printf "\\e[1;38;5;154mThe APK %s file can be installed from ~/${RDR##*/}/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
fi
printf "\\e[?25h\\e[1;7;38;5;34mShare %s everwhere%s!\\e[0m\\n" "https://wiki.termux.com/wiki/Development" "🌎🌍🌏🌐"
# build.one.bash EOF
