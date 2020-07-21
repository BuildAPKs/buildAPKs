#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s nullglob globstar
RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/init/atrap.bash 137 138 139 "${0##*/} ushlibs.bash" 
	declare -A ARSHLIBS # declare associative array for available submodules
	ARSHLIBS=([scripts/bash/shlibs]="shlibs/shlibs.bash" [scripts/sh/shlibs]="shlibs/shlibs.sh" [opt/api/github]="BuildAPKs/buildAPKs.github" [opt/db]="BuildAPKs/db.BuildAPKs")

	for MLOC in "${!ARSHLIBS[@]}" 
	do
		echo $MLOC "${ARSHLIBS[$MLOC]}" 
		echo "${#ARSHLIBS[$MLOC]}" 
		echo "${#ARSHLIBS[@]}" 
	done
