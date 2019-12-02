#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by BuildAPKs 
# See LICENSE for details https://buildapks.github.io/docsBuildAPKs/
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/init/atrap.bash 201 211 221 "${0##*/} setup.buildAPKs.bash"
_INPKGS_() {
	if [[ "$COMMANDIF" = au ]] 
	then 
		au $(echo ${PKGS[@]}) || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
	else
		apt install $(echo ${PKGS[@]}) || printf "\\e[1;37;5;116m%s\\e[0m\\n" "$STRING2"
	fi
}

declare COMMANDR
declare COMMANDIF
declare STRING1
declare STRING2
declare RDR
STRING1="COMMAND \`au\` enables rollback, available at https://wae.github.io/au/ IS NOT FOUND: Continuing... "
STRING2="Cannot update ~/${RDR##*/} prerequisite: Continuing..."
printf "\\e[1;38;5;115m%s\\e[0m\\n" "Beginning buildAPKs setup:"
COMMANDR="$(command -v au)" || (printf "%s\\n\\n" "$STRING1") 
COMMANDIF="${COMMANDR##*/}"
PKGS=(aapt apksigner curl dx ecj findutils git)
for PKG in "${PKGS[@]}"
do
	COMMANDP="$(command -v $PKG)" || printf "Command %s not found: Continuing...\\n""$PKG"
	COMMANDPF="${COMMANDP##*/}"
	if [[ "$COMMANDPF" != "$PKG" ]] 
	then 
		_INPKGS_
	fi
done
if [[ ! -d "$RDR" ]]
then
	cd "$HOME" && git clone https://github.com/BuildAPKs/buildAPKs || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
fi
export JAD=github.com/BuildAPKs/buildAPKs.entertainment
export JID=entertainment # job id/name
bash "$RDR"/scripts/bash/init/init.bash "$@"
# setup.buildAPKs.bash EOF
