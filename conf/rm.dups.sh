#!/bin/env sh
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Deletes duplicate names from NUNAME file.
# All names that build are: cat ONAMES UNAMES
#####################################################################
set -e
printf "Proccessing duplicate names in NUNAMES.  Please wait..."
for NAME in $(cat [CEOPUZ]NAMES | sort | uniq)
do
	grep -iv "$NAME" NUNAMES > TEMP.FILE
	mv TEMP.FILE NUNAMES
done
printf "  DONE\\n"
# rm.dups.sh EOF
