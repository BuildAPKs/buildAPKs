#!/bin/env bash
# Copyright 2019 (c) all rights reserved by S D Rausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# To create checksum files and commit use; ./do.sums.bash
# To see file tree use; awk '{print $2}' sha512.sum
# To check the files use; sha512sum -c sha512.sum
#####################################################################
set -eu
MTIME="$(ls -l --time-style=+"%s" .git/FETCH_HEAD | awk '{print $6}')"
TIME="$(date +%s)"
(if [[ $(($TIME - $MTIME)) -gt 43200 ]];then git pull;fi) || git pull
./scripts/maintenance/vgen.sh
rm -f *.sum
FILELIST=( $(find . -type f | grep -wv .git | sort) )
CHECKLIST=(sha512sum) # md5sum sha1sum sha224sum sha256sum sha384sum
for SCHECK in ${CHECKLIST[@]}
do
 	printf "%s\\n" "Creating $SCHECK file..."
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
SN="$(sn.sh)" # sn.sh is found in maintenance.BuildAPKs
git commit -m "$SN"
git push
ls
printf "%s\\n" "$PWD"
# do.sums.bash EOF
