#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e
FILELIST=( $(find . -type f | grep -v .git | sort) )
CHECKLIST=("md5sum" "sha1sum" "sha256sum" "sha512sum")
rm -f *.sum
for FILE in "${FILELIST[@]}"
do
	for SCHECK in "${CHECKLIST[@]}"
	do
		printf "%s\\n" "Creating $SCHECK for $FILE..."
		$SCHECK $FILE >> $SCHECK.sum
	done
done
sed -i '/[0-9]sum.sum/d' *.sum
for SRCHECK in  "${CHECKLIST[@]}"
do
	printf "\\nChecking $SRCHECK...\\n"
	$SRCHECK -c $SRCHECK.sum
done
# make.sums.sh EOF
