#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# installs and updates submodules from https://github.com/shlibs
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/init/atrap.bash 137 138 139 "${0##*/} ushlibs.bash" 
_IFSHLIBS_() { 
	if [[ ! -d "$RDR"/scripts/bash/shlibs ]] 
	then
		git clone https://github.com/shlibs/shlibs.bash scripts/bash/shlibs || printf "\\nCannot clone module %s into~/%s/scripts/bash/shlibs: Continuing...\\n\\n" "https://github.com/shlibs/shlibs.bash" "${RDR##*/}"
		sleep 0.$(shuf -i 24-72 -n 1) # add network latency support on fast networks 
	fi
	if [[ ! -d "$RDR"/scripts/sh/shlibs ]] 
	then
		git clone https://github.com/shlibs/shlibs.sh scripts/sh/shlibs || printf "\\nCannot clone module %s into~/%s/scripts/bash/shlibs: Continuing...\\n\\n" "https://github.com/shlibs/shlibs.sh" "${RDR##*/}"
		sleep 0.$(shuf -i 24-72 -n 1) # increase network latency support on fast networks 
	fi
}

_IRGR_() { # https://stackoverflow.com/questions/53977052/how-to-properly-initialize-a-remote-git-repository 
		local USER="BuildAPKs"
		local HOSTIP="github.com"
		local PROJECT="buildAPKs"
		git init 
		git remote add origin ssh://${USER}@${HOSTIP}${PROJECT}.git
}

_UFSHLIBS_() { # add and update submodules 
	declare -A ARSHLIBS # declare associative array for available submodules
	ARSHLIBS=([bash/shlibs]="shlibs/shlibs.bash" [sh/shlibs]="shlibs/shlibs.sh")
	for MLOC in "${!ARSHLIBS[@]}" 
	do
		if grep "${ARSHLIBS[$MLOC]}" .gitmodules >/dev/null  
		then
		rm -f scripts/$MLOC/.git
 		printf "\\e[1;7;38;5;96mUpdating ~/%s/scripts/%s...\\e[0m\\n" "${RDR##*/}" "$MLOC" ; git submodule update --recursive --remote scripts/$MLOC || printf "Cannot update module ~/%s/scripts/%s: Continuing...\\n" "${RDR##*/}" "$MLOC"
		sleep 0.$(shuf -i 24-72 -n 1) # add network latency support on fast networks 
		fi
	done
	for MLOC in "${!ARSHLIBS[@]}" 
	do
		if ! grep "${ARSHLIBS[$MLOC]}" .gitmodules 1>/dev/null  
		then
 			printf "\\e[1;7;38;5;96mAdding ~/%s/scripts/%s...\\e[0m\\n" "${RDR##*/}" "$MLOC" ; git submodule add https://github.com/${ARSHLIBS[$MLOC]} scripts/$MLOC || printf "Cannot add submodule ~/%s/scripts/%s: Continuing...\\n" "${RDR##*/}" "$MLOC"
		sleep 0.$(shuf -i 24-72 -n 1) # increase network latency support on fast networks 
		fi
	done
}

cd "$RDR"
if [[ ! -d "$RDR"/.git ]] 
then
	_IRGR_
	sleep 0.$(shuf -i 24-72 -n 1) # add network latency support on fast networks 
	_IFSHLIBS_
fi
if [[ ! -f "$RDR"/scripts/bash/shlibs/.git ]] || [[ ! -f "$RDR"/scripts/sh/shlibs/.git ]] 
then
	git pull || printf "\\nCannot update ~/%s: Continuing...\\n\\n" "${RDR##*/}"
	sleep 0.$(shuf -i 24-72 -n 1) # add network latency support on fast networks 
	_UFSHLIBS_
fi
# ushlibs.bash EOF
