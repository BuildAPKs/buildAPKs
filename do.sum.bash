#!/bin/env bash
# Copyright 2019 (c) all rights reserved by S D Rausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# To create the checksum file and commit use; ./do.sum.bash
# To see the file tree use; awk '{ print $2 }' md5.sum
# To check the files use; md5sum -c md5.sum
#####################################################################
set -eu
git pull
rm -f *.sum
FILELIST=( $(find . -type f | grep -vw .git | sort) )
CHECKLIST=(md5sum)
for SCHECK in ${CHECKLIST[@]}
do
 	printf "%s\\n" "Creating $SCHECK file: Please wait a moment..."
	for FILE in "${FILELIST[@]}"
	do
		$SCHECK "$FILE" >> ${SCHECK::-3}.sum
	done
	chmod 400 ${SCHECK::-3}.sum
done
for SCHECK in  ${CHECKLIST[@]}
do
	printf  "\\n%s\\n" "Checking $SCHECK..."
	$SCHECK -c ${SCHECK::-3}.sum
done
git add .
git commit
git push
ls
printf "\\e[1;38;5;112m%s\\e[0m\\n" "$PWD"
# do.sum.sh EOF
