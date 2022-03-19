#!/usr/bin/env bash
# See https://buildapks.github.io/ LICENSE for details.
# Copyright 2017-2022 (c) all rights reserved by BuildAPKs
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
_SUPTRPERROR_() { # Run on script error.
local RV="$?"
printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.bash ERROR:  Signal %s received!\\e[0m\\n" "$RV"
printf "\\e[?25h\\e[0m\\n"
exit 201
}

_SUPTRPEXIT_() { # Run on exit.
local RV="$?"
sleep 0.0$(shuf -i 24-72 -n 1) # add device latency support
if [[ "$RV" = 0 ]]
then
printf "\\e[1;7;38;5;155m%s %s \\e[0m\\e[1;34m: \\e[1;32m%s\\e[0m\\n\\n\\e[0m" "${0##*/}" "$ARGS" "DONE 🏁 "
printf "\\e]2; %s: %s \\007" "${0##*/} $ARGS" "DONE 🏁 "
else
printf "\\a\\e[1;7;38;5;88m%s %s \\a\\e[0m\\e[1;34m: \\a\\e[1;32m%s %s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "[Exit Signal $RV]" "DONE 🏁 "
printf "\\033]2; %s: %s %s \\007" "${0##*/} $ARGS" "[Exit Signal $RV]" "DONE 🏁 "
fi
printf "\\e[?25h\\e[0m"
set +Eeuo pipefail
exit
}

_SUPTRPSIGNAL_() { # Run on signal.
local RV="$?"
printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.bash WARNING:  Signal %s received!\\e[0m\\n" "$RV"
exit 211
}

_SUPTRPQUIT_() { # Run on quit.
local RV="$?"
printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.bash WARNING:  Quit signal %s received!\\e[0m\\n" "$RV"
exit 221
}

trap '_SUPTRPERROR_ $LINENO $BASH_COMMAND $?' ERR
trap _SUPTRPEXIT_ EXIT
trap _SUPTRPSIGNAL_ HUP INT TERM
trap _SUPTRPQUIT_ QUIT

_INPKGS_() {
if [[ "$COMMANDIF" = au ]]
then
au "${PKGS[@]}" || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
else
if [[ -z "${COMMANDAPTUP:-}" ]]
then
COMMANDAPTUP=0
( apt update && apt upgrade -y && apt install -y "${PKGS[@]}" ) || printf "\\e[1;37;5;116m%s\\e[0m\\n" "$STRING2"
else
apt install -y "${PKGS[@]}" || printf "\\e[1;37;5;116m%s\\e[0m\\n" "$STRING2"
fi
fi
}

declare -a ARGS="$@"
declare COMMANDR
declare COMMANDIF
declare STRING1
declare STRING2
declare RDR
export RDR="$HOME/buildAPKs"
STRING1="COMMAND \`au\` enables rollback, available at https://wae.github.io/au/ IS NOT FOUND: Continuing... "
STRING2="Cannot update ~/${RDR##*/} prerequisite: Continuing..."
PKGS=(aapt openssl-tool curl dx ecj git)
if [[ -z "${1:-}" ]]
then
ARGS=""
fi
printf "\\e[1;38;5;115m%s\\e[0m\\n" "Beginning buildAPKs setup:"
COMMANDR="$(command -v au)" || (printf "%s\\n\\n" "$STRING1")
COMMANDIF="${COMMANDR##*/}"
for PKG in "${PKGS[@]}"
do
[ "$PKG" = "openssl-tool" ] && PKG=openssl
COMMANDP="$(command -v "$PKG")" || printf "Command %s not found: Continuing...\\n" "$PKG" # test if command exists
COMMANDPF="${COMMANDP##*/}"
[ "$COMMANDPF" = openssl ] && PKG=openssl
if [[ "$COMMANDPF" != "$PKG" ]]
then
_INPKGS_
fi
done
if [[ ! -d "$RDR" ]]
then
cd && git clone --depth 1 https://github.com/BuildAPKs/buildAPKs --branch master --single-branch || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
fi
if [[ -z "${PREFIX:-}" ]]
then
if [ ! -e "/etc/profile.d/buildAPKs.sh" ]
then
cat > "/etc/profile.d/buildAPKs.sh" <<- EOM
if [ -d "$HOME/buildAPKs/bin/" ]
then
PATH="\$PATH:\$HOME/buildAPKs/bin/"
fi
EOM
fi
else
if [ ! -e "$PREFIX/etc/profile.d/buildAPKs.sh" ]
then
cat > "$PREFIX/etc/profile.d/buildAPKs.sh" <<- EOM
if [ -d "$HOME/buildAPKs/bin/" ]
then
PATH="\$PATH:\$HOME/buildAPKs/bin/"
fi
EOM
fi
fi
export JAD=github.com/BuildAPKs/buildAPKs.entertainment	# job address
export JID=entertainment	# job id/name
bash "$RDR"/scripts/bash/init/init.bash "$@"
! grep "setup.buildAPKs.bash" "$RDR"/sha512.sum 1>/dev/null || sed -i "/setup.buildAPKs.bash/d" "$RDR"/sha512.sum
# setup.buildAPKs.bash EOF
