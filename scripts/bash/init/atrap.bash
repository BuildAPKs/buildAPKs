#!/usr/bin/env bash
# Copyright 2019-2021 (c) all rights reserved by S D Rausty; see LICENSE
# https://sdrausty.github.io published courtesy https://pages.github.com
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
_SBTRPERROR_() { # run on script error
	local RV="$?"
	if [[ "$RV" == 1 ]]
	then
		printf "\\n\\e[1;48;5;130mERROR return value %s received by %s %s:  Exiting due to error signal %s near or at line number %s by \`%s\` with return value %s.,.\\e[0m\\n" "$RV" "$TPARENT" "${0##*/} trap.bash" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
		exit $TERROR
	else
		printf "\\n\\e[1;48;5;138mBuildAPKs %s %s  ERROR:  Generated script error signal %s near or at line number %s by \`%s\` with return value %s\\e.,.[0m\\n" "$TPARENT" "${0##*/} trap.bash" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
		exit $TERROR
	fi
	_WAKEUNLOCK_
	printf "\\e[?25h"
	set +Eeuo pipefail
 	exit $TERROR
}

_SBTRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]
	then
		printf "%s\\n" "Signal $RV exit received by $TPARENT trap.bash:  Exiting..."
	else
		_WAKEUNLOCK_
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail
	exit 0
}

_SBTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\n\\e[1;48;5;138mBuildAPKs %s trap.bash WARNING:  Signal signal %s received near or at line number %s by \`%s\` with return value %s:  Exiting...\\e[0m\\n" "$TPARENT" "${0##*/} trap.bash" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
	_WAKEUNLOCK_
	printf "\\e[?25h"
	set +Eeuo pipefail
 	exit $TSIGNAL
}

_SBTRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\n\\e[1;48;5;138mBuildAPKs %s %s WARNING:  Quit signal %s received near or at line number %s by \`%s\` with return value %s:  Exiting...\\e[0m\\n" "$TPARENT" "${0##*/} trap.bash" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail
 	exit $TQUIT
}

trap '_SBTRPERROR_ $LINENO $BASH_COMMAND $?' ERR
trap _SBTRPEXIT_ EXIT
trap '_SBTRPSIGNAL_ $LINENO $BASH_COMMAND $?' HUP INT TERM
trap '_SBTRPQUIT_ $LINENO $BASH_COMMAND $?' QUIT

_MAINLOCK_ () {
	if [[ -z "${5:-}" ]]
	then
		_WAKELOCK_
	elif [[ "$5" = "wake.idle" ]]
	then
		export WAKEST="idle"
	elif [[ "$5" = "wake.start" ]]
	then
		_WAKELOCK_
		export WAKEST="block"
	elif [[ "$5" = "wake.stop" ]]
	then
		export WAKEST="unblock"
	fi
}


_WAKELOCK_() {
	if [[ -z "${WAKEST:-}" ]]
	then
		_PRINTWLA_
		am startservice --user 0 -a com.termux.service_wake_lock com.termux/com.termux.app.TermuxService 1>/dev/null || printf "%s\\n" "Unable to process am startservice: Continuing..."
		[ ! -e "$RDR/var/lock" ] && mkdir -p "$RDR/var/lock"
		touch "$RDR/var/lock/wake.$PPID.lock"
		_PRINTDONE_
	fi
}

_WAKEUNLOCK_() { # check for state, locks and unlock if lock files are not found
	if [[ -z "${WAKEST:-}" ]] || [[ "$WAKEST" == "unblock" ]] # check for state
	then	 # https://unix.stackexchange.com/questions/46541/how-can-i-use-bashs-if-test-and-find-commands-together
		_PRINTWLD_
		rm -f "$RDR/var/lock/wake.$PPID.lock"
		if [[ -n $(find "$RDR/var/lock" -name "*.lock") ]] # lock files are found
		then 	# do not release wake lock
			printf '\033]2;Releasing wake lock: Pending...\007'
			if [[ $(find "$RDR/var/lock" -type f | wc -l) -gt 1 ]]
			then
				printf "\\e[1;33mNOT RELEASED.  \\e[1;32mOther lock files are present in ~/%s/var/lock:\\e[0m" "${RDR##*/}"
			else
				if [[ -f "$RDR/var/lock/set.lock" ]]
				then
					printf "\\e[1;33mNOT RELEASED.  \\e[1;32m%s\\e[0m" "Found set.lock file!"
				else
					printf "\\e[1;33mNOT RELEASED.  \\e[1;32mAnother lock file is present in ~/%s/var/lock:\\e[0m" "${RDR##*/}"
				fi
			fi
			printf "\\n\\n\\e[1;33m"
			ls "$RDR/var/lock"
			printf "\\n\\e[1;38;5;187mYou can safely delete ~/%s/var/lock if no other jobs are running.\\e[0m\\n\\n" "${RDR##*/}"
			_PRINTHELP_
		else 	# release wake lock when there are no lock files found
			cd "$RDR"
			am startservice --user 0 -a com.termux.service_wake_unlock com.termux/com.termux.app.TermuxService > /dev/null || printf "%s\\n" "Unable to process am startservice: Continuing..."
			_PRINTDONE_
			_PRINTHELP_
		fi
	fi
}

_PRINTHELP_() {
	if [[ ! -f "$RDR/var/lock/set.lock" ]]
	then
		printf "\\e[1;38;5;107m%s\\e[1;38;5;109m%s\\e[0m\\n" "To always have wake lock set to on: " "touch ~/${RDR##*/}/var/lock/set.lock"
	fi
}

_PRINTDONE_() {
	printf "\\e[1;32mDONE\\e[0m\\n"
}

_PRINTWLA_() {
	printf "\\e[1;34mActivating wake lock: "'\033]2;Activating wake lock: OK\007'
}

_PRINTWLD_() {
	printf "\\e[1;34mReleasing wake lock: "'\033]2;Releasing wake lock: OK\007'
}

_INITLOCK_ () {
	COMMANDIF="$(command -v am)" || printf "%s\\n" "Unable to process am startservice: Continuing..."
	if [[ "$COMMANDIF" = "" ]]
	then
		printf "\\n\\e[1;48;5;138m %s\\e[0m\\n\\n" "BuildAPKs WARNING: File ${0##*/} trap.bash cannot use wake lock!"
	else
		_MAINLOCK_ "$@"
	fi
}

NARGS="${#@}"
TQUIT="$1"
TSIGNAL="$2"
TERROR="$3"
TPARENT="${4:-UNDEFINED}"
if [[ ! -z "${5:-}" ]]
then
	_INITLOCK_ "$5"
fi
# trap.bash EOF
