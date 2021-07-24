#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
# installs and updates submodules from https://github.com/shlibs
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/init/atrap.bash 137 138 139 "${0##*/} ushlibs.bash"
_IRGR_() { # initialize a remote git repository
		local USER="BuildAPKs"
		local HOSTIP="github.com"
		local PROJECT="buildAPKs"
		git init
		git remote add origin ssh://${USER}@${HOSTIP}${PROJECT}.git
}

_UFSHLIBS_() { # add and update submodules
	declare -A ARSHLIBS # declare associative array for available submodules
	ARSHLIBS=([scripts/bash/shlibs]="shlibs/shlibs.bash" [scripts/sh/shlibs]="shlibs/shlibs.sh" [opt/api/github]="BuildAPKs/buildAPKs.github" [opt/db]="BuildAPKs/db.BuildAPKs")
	printf "\\e[1;7;38;5;98mInstalling %s prerequisite components of ~/%s/:\\e[0m\\n" "${#ARSHLIBS[@]}" "${RDR##*/}"
	for MLOC in "${!ARSHLIBS[@]}"
	do
		if grep "${ARSHLIBS[$MLOC]}" .gitmodules >/dev/null
		then
		rm -f scripts/$MLOC/.git
 		printf "\\e[1;7;38;5;96mUpdating submodule ~/%s/%s from Internet site %s address:\\e[0m\\n" "${RDR##*/}" "$MLOC" "$SIAD/${ARSHLIBS[$MLOC]}" ; git submodule update --depth 1 --recursive --remote "$MLOC" || printf "Cannot update module ~/%s/scripts/%s: Continuing...\\n" "${RDR##*/}" "$MLOC"
		sleep 0.$(shuf -i 24-72 -n 1) # add network latency support on fast networks
		fi
	done
	for MLOC in "${!ARSHLIBS[@]}"
	do
		if ! grep "${ARSHLIBS[$MLOC]}" .gitmodules 1>/dev/null
		then
 			printf "\\e[1;7;38;5;96mAdding ~/%s/scripts/%s...\\e[0m\\n" "${RDR##*/}" "$MLOC" ; git submodule add --depth 1 "https://github.com/${ARSHLIBS[$MLOC]}" "$MLOC" || printf "Cannot add submodule ~/%s/scripts/%s: Continuing...\\n" "${RDR##*/}" "$MLOC"
		sleep 0.$(shuf -i 24-72 -n 1) # increase network latency support on fast networks
		fi
	done
}

SIAD="https://github.com" # define site address
[ ! -d "$RDR"/.git ] && _IRGR_ && sleep 0.$(shuf -i 24-72 -n 1)
if [[ ! -f "$RDR"/scripts/bash/shlibs/.git ]] || [[ ! -f "$RDR"/scripts/sh/shlibs/.git ]]
then
	cd "$RDR"
	git pull --ff-only || printf "\\nCannot update ~/%s: Continuing...\\n\\n" "${RDR##*/}"
	sleep 0.$(shuf -i 24-72 -n 1) # add network latency support on fast networks
	_UFSHLIBS_
fi
# ushlibs.bash EOF
