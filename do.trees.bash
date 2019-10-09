#!/bin/env bash
# Copyright 2019 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
# Checks sha512sum files: sha512sum -c trees.sha512sum.sum
# Creates trees.*.sum files: ./do.trees.bash
#####################################################################
set -eu
rm -f *.sum
FILELIST=( $(find . -type f | grep -v .git | sort) )
CHECKLIST=("md5sum" "sha1sum" "sha224sum" "sha256sum" "sha384sum" "sha512sum")
for SCHECK in "${CHECKLIST[@]}"
do
	for FILE in "${FILELIST[@]}"
	do
 		printf "%s\\n" "Creating $SCHECK for $FILE..."
		"$SCHECK" "$FILE" >> trees."$SCHECK".sum
	done
done
for SRCHECK in  "${CHECKLIST[@]}"
do
	printf "\\nChecking $SRCHECK...\\n"
	"$SRCHECK" -c trees."$SRCHECK".sum
done
git add .
git commit
git push
# do.trees.sh EOF
