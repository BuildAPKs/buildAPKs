#!/usr/bin/env ksh
# Copyright 2020-2021 (c) all rights reserved
# by BuildAPKs https://buildapks.github.io/buildAPKs/
# See LICENSE for details https://buildapks.github.io/docsBuildAPKs/
#####################################################################
set -e
[ -z "${RDR:-}" ] && RDR="$HOME/buildAPKs"
[ "$PWD" = "${PREFIX%/*}" ] || [ "$PWD" = "$PREFIX" ] || [ "$PWD" = "$HOME" ] || [ "$PWD" = "$RDR" ] && { printf "Signal 224 generated in %s;  Command '${0##*/}' cannot be run in directory %s; %s exiting...\\n" "$PWD" "$PWD" "${0##*/} build.one.bash" ; exit 224 ; }
for CMD in aapt apksigner dx ecj
do
       	[ -z "$(command -v "$CMD")" ] && printf "%s\\n" " \"$CMD\" not found" && NOTFOUND=1
done
[ "$NOTFOUND" = "1" ] && exit
[ "$1" ] && [ -f "$1/AndroidManifest.xml" ] && cd "$1"
[ -f AndroidManifest.xml ] || exit

_CLEANUP_() {
       	printf "\\n\\n%s\\n" "Completing tasks..."
       	[ "$CLEAN" = "1" ] && mv "output/$PKGNAME.apk" .
      	rmdir assets 2>/dev/null ||:
       	rmdir res 2>/dev/null ||:
       	rm -rf output
       	rm -rf gen
       	rm -rf obj
	printf "\\n\\n%s\\n\\n" "Share https://wiki.termux.com/wiki/Development everwhere🌎🌍🌏🌐!"
}

_UNTP_() {
       	printf "\\n\\n%s\\n\\n\\n""Unable to process"
       	_CLEANUP_
       	exit
}

PKGNAME="$(grep -o "package=.*" AndroidManifest.xml | cut -d\" -f2)"


printf "%s\\n" "Beginning build"
[ -d assets ] || mkdir assets
[ -d res ] || mkdir res
mkdir -p output
mkdir -p gen
mkdir -p obj


printf "%s\\n" "aapt: started..."
aapt package -f -m \
       	-M "AndroidManifest.xml" \
       	-J "gen" \
       	-S "res" || _UNTP_
printf "%s\\n\\n" "aapt: done"


printf "%s\\n" "ecj: begun..."
for JAVAFILE in $(find . -type f -name "*.java")
do
       	JAVAFILES="$JAVAFILES $JAVAFILE"
done
ecj -d obj -sourcepath . $JAVAFILES || _UNTP_
printf "%s\\n\\n" "ecj: done"


printf "%s\\n" "dx: started..."
dx --dex --output=output/classes.dex obj || _UNTP_
printf "%s\\n\\n" "dx: done"


printf "%s\\n" "Making $PKGNAME.apk..."
aapt package -f \
       	--min-sdk-version 1 \
       	--target-sdk-version 23 \
       	-M AndroidManifest.xml \
       	-S res \
       	-A assets \
       	-F output/"$PKGNAME.apk" || _UNTP_


printf "\n%s\\n" "Adding classes.dex to $PKGNAME.apk..."
cd output || _UNTP_
aapt add -f "$PKGNAME.apk" classes.dex || { cd ..; _UNTP_; }

printf "\n%s" "Signing $PKGNAME.apk: "
apksigner sign --cert "$RDR/opt/key/certificate.pem" --key "$RDR/opt/key/key.pk8" "$PKGNAME.apk" || { cd ..; _UNTP_; }
printf "%s\\n" "DONE"
printf "%s" "Verifying $PKGNAME.apk: "
apksigner verify --verbose "$PKGNAME.apk" || { cd ..; _UNTP_; }
printf "%s\\n" "DONE"

cd ..

CLEAN=1
_CLEANUP_
# build.ksh EOF
