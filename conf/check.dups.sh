#!/bin/env sh
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Deletes duplicate names from NUNAME file.
#####################################################################
set -e
for NAME in $(cat UNAMES)
do
	grep -iv "$NAME" NUNAMES > temp.file
	mv temp.file NUNAMES
done
for NAME in $(cat ONAMES)
do
	grep -iv "$NAME" NUNAMES > temp.file
	mv temp.file NUNAMES
done
