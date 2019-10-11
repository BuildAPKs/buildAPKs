#!/bin/env bash
# Copyright 2019 (c) all rights reserved by S D Rausty; see LICENSE  
# https://sdrausty.github.io courtesy https://pages.github.com
# To check sha512sum file use; sha512sum -c ztree.sha512.sum
# To create checksum files and commit use; ./do.sums.bash
#####################################################################
set -eu
rm -f *.sum
FILELIST=( $(find . -type f | grep -v .git | sort) )
CHECKLIST=(md5sum sha1sum sha224sum sha256sum sha384sum sha512sum)
for SCHECK in ${CHECKLIST[@]}
do
 	printf "%s\\n" "Creating $SCHECK file: Please wait a moment..."
	for FILE in "${FILELIST[@]}"
	do
		$SCHECK "$FILE" >> ztree.${SCHECK::-3}.sum
	done
done
for SCHECK in  ${CHECKLIST[@]}
do
	printf  "\\n%s\\n" "Checking $SCHECK..."
	$SCHECK -c ztree.${SCHECK::-3}.sum
done
git add .
git commit
git push
ls -ao
# do.sums.sh EOF
