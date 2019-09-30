#!/bin/env bash
# Copyright 2019 (c) all rights reserved by BuildAPKs see LICENSE
# buildapks.github.io/buildAPKs published courtesy pages.github.com
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SITRPERROR_() { # run on script error
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs build.github.what.is.it.bash %s WARNING:  Error %s received!\\e[0m\\n" "${0##*/}" "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs build.github.what.is.it.bash %s %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${0##*/}" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	_WAKEUNLOCK_
	exit 147
}

_SITRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SITRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs build.github.what.is.it.bash %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
        printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs build.github.what.is.it.bash %s WARNING:  Signal %s received near or at line number %s by \`%s\`!\\e[0m\\n" "${0##*/}" "${1:-UNDEFINED}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	_WAKEUNLOCK_
 	exit 148 
}

_SITRPQuIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs build.github.what.is.it.bash %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
        printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs build.github.what.is.it.bash %s WARNING:  Quit signal %s received near or at line number %s by \`%s\`!\\e[0m\\n" "${0##*/}" "${1:-UNDEFINED}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	_WAKEUNLOCK_
 	exit 149 
}

trap '_SITRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SITRPEXIT_ EXIT
trap '_SITRPSIGNAL_ $? $LINENO $BASH_COMMAND'  HUP INT TERM
trap '_SITRPQuIT_ $? $LINENO $BASH_COMMAND' QUIT 

if [[ -z "${1:-}" ]] 
then
	printf "\\e[1;7;38;5;204m%s\\n\\e[0m\\n" "GitHub name must be provided;  See \`~/${RDR##*/}/conf/UNAMES\` for usernames that build APKs on device with BuildAPKs!  To build all the user names contained in this file run \`for i in \$(cat ~/${RDR##*/}/conf/UNAMES) ; do ~/${RDR##*/}/scripts/bash/build/${0##*/} \$i ; done\`.  File \`~/${RDR##*/}/conf/GAUTH\` has important information should you choose to run this command regarding bandwidth supplied by GitHub. "
	exit 227
fi
export UI="${1%/}"
export UIT="${UI##*/}"
read TYPE < <(curl "https://api.github.com/users/$UIT/repos" -s 2>&1 | head -n 25 | tail -n 1 | grep -o Organization) # https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell/
if [[ "$TYPE" == Organization ]]
then
	"$RDR"/scripts/bash/build/build.github.orgs.bash "$UIT"
else
	"$RDR"/scripts/bash/build/build.github.users.bash "$UIT"
fi

# build.github.what.is.it.bash OEF
