#!/bin/env bash
# Copyright 2019 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
# Invocation0 creates trees.*.sum files: ./do.sums.bash
# Invocation1 checks md5sum: md5sum.sum -c trees.md5sum.sum
#####################################################################
set -eu
rm -f *.sum
FILELIST=( $(find . -type f | grep -v .git | sort) )
CHECKLIST=("md5sum" "sha1sum" "sha224sum" "sha256sum" "sha384sum" "sha512sum")
for FILE in "${FILELIST[@]}"
do
	for SCHECK in "${CHECKLIST[@]}"
	do
 		printf "%s\\n" "Creating $SCHECK for $FILE..."
		$SCHECK $FILE >> trees.$SCHECK.sum
	done
done
for SRCHECK in  "${CHECKLIST[@]}"
do
	printf "\\nChecking $SRCHECK...\\n"
	$SRCHECK -c trees.$SRCHECK.sum
done
# do.sums.sh EOF
