#!/system/bin/sh 

for i in aapt ecj dx apksigner; do
  [ -z "$(command -v $i)" ] && echo " \"$i\" not found" && notfound=1
done
[ "$notfound" = "1" ] && exit
[ "$1" ] && [ -f "$1/AndroidManifest.xml" ] && cd "$1"
[ -f AndroidManifest.xml ] || exit

cleanup() {
  echo "\n\nCleaning up..."
  [ "$clean" = "1" ] && mv "bin/${PKGNAME}-signed.apk" .
  rmdir assets 2>/dev/null
  rmdir res 2>/dev/null
  rm -rf bin
  rm -rf gen
  rm -rf obj
}

failed() {
  echo  "\n\n\n Unable to process\n\n\n"
  cleanup; exit
}

PKGNAME="$(grep -o "package=.*" AndroidManifest.xml | cut -d\" -f2)"


echo "Beginning build"
[ -d assets ] || mkdir assets
[ -d res ] || mkdir res
mkdir bin
mkdir gen
mkdir obj


echo "aapt: started..."
aapt package -f -m \
    -M "AndroidManifest.xml" \
    -J "gen" \
    -S "res" || failed
echo "aapt: done\n"


echo "ecj: begun..."
for file in $(find . -type f -name "*.java"); do
  javafiles="$javafiles $file"
done
ecj -d obj -sourcepath . $javafiles || failed
echo "ecj: done\n"


echo "dx: started..."
dx --dex --output=bin/classes.dex obj || failed
echo "dx: done\n"


echo "Making ${PKGNAME}.apk..."
aapt package -f \
    --min-sdk-version 1 \
    --target-sdk-version 23 \
    -M AndroidManifest.xml \
    -S res \
    -A assets \
    -F bin/"${PKGNAME}.apk" || failed


echo "\nAdding classes.dex to ${PKGNAME}.apk..."
cd bin
aapt add -f "${PKGNAME}.apk" classes.dex || { cd ..; failed; }

echo "\nSigning $PKGNAME.apk..."
apksigner "${PKGNAME}-debug.key" "${PKGNAME}.apk" "${PKGNAME}-signed.apk" || { cd ..; failed; }

cd ..

clean=1
cleanup
echo "\n\nShare https://wiki.termux.com/wiki/Development everwhere🌎🌍🌏🌐!"
