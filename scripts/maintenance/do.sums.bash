#!/bin/env bash
# Copyright 2019 (c) all rights reserved by S D Rausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# To create checksum files and commit use; ./do.sums.bash
# To see file tree use; awk '{print $2}' sha512.sum
# To check the files use; sha512sum -c sha512.sum
#####################################################################
set -eu
git pull
./scripts/maintenance/vgen.sh
rm -f *.sum
FILELIST=( $(find . -type f | grep -v .git | sort) )
CHECKLIST=(sha512sum)
for SCHECK in ${CHECKLIST[@]}
do
 	printf "%s\\n" "Creating $SCHECK file: Please wait a moment..."
	for FILE in "${FILELIST[@]}"
	do
		$SCHECK "$FILE" >> ${SCHECK::-3}.sum
	done
done
chmod 400 ${SCHECK::-3}.sum 
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
# do.sums.bash EOF
