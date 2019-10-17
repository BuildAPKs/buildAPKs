#!/bin/env sh
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Deletes duplicate names from NUNAME file.
#####################################################################
set -e
for NAME in $(cat [OU]NAMES | sort | uniq)
do
	grep -iv "$NAME" NUNAMES > TEMP.FILE
	mv TEMP.FILE NUNAMES
done
# rm.dup.names.sh EOF
