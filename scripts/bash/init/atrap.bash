#!/usr/bin/env bash
# Copyright 2019 (c) all rights reserved ; See LICENSE 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
_SATRPERROR_() { # run on script error
	local RV="$?"
	if [[ "$RV" == 1 ]]  
	then 
		printf "\\n\\e[1;48;5;130mERROR return value %s received by %s %s:  Exiting due to error signal %s near or at line number %s by \`%s\` with return value %s.,.\\e[0m\\n" "$RV" "$ATPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
		exit $ATERROR
	else
		printf "\\n\\e[1;48;5;138mBuildAPKs %s %s  ERROR:  Generated script error signal %s near or at line number %s by \`%s\` with return value %s\\e.,.[0m\\n" "$ATPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
		exit $ATERROR
	fi
	printf "\\e[?25h"
	set +Eeuo pipefail 
 	exit $ATERROR
}

_SATRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		printf "%s\\n" "Signal $RV received by $ATPARENT atrap.bash:  Exiting..." 
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SATRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\n\\e[1;48;5;138mBuildAPKs %s atrap.bash WARNING:  Signal %s received near or at line number %s by \`%s\` with return value %s:  Exiting...\\e[0m\\n" "$ATPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
	printf "\\e[?25h"
	set +Eeuo pipefail 
 	exit $ATSIGNAL
}

_SATRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\n\\e[1;48;5;138mBuildAPKs %s %s WARNING:  Quit signal %s received near or at line number %s by \`%s\` with return value %s:  Exiting...\\e[0m\\n" "$ATPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
 	exit $ATQUIT
}

trap '_SATRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SATRPEXIT_ EXIT
trap '_SATRPSIGNAL_ $LINENO $BASH_COMMAND $?' HUP INT TERM
trap '_SATRPQUIT_ $LINENO $BASH_COMMAND $?' QUIT 

ATQUIT="$1"
ATSIGNAL="$2"
ATERROR="$3"
ATPARENT="${4:-UNDEFINED}"
# atrap.bash EOF
