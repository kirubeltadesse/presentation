#!/bin/bash

purge() {       # remove a specific build folder
    local FOLDER=$1
    print "warning" "Purging build/ in ${FOLDER}"
    cd build/
    rm -rf ${FOLDER}
}

# Define the function to echo colored text
print() {
	local type="$1"
	local text="$2"

	# Text color codes
	local RED='\033[0;31m'
	local GREEN='\033[0;32m'
	local YELLOW='\033[0;33m'
	local BLUE='\033[0;34m'
	local NC='\033[0m' # No color

	local color=$NC

	case "$type" in
	error)
		color=$RED
		;;
	warning)
		color=$YELLOW
		;;
	progress)
		color=$BLUE
		;;
	success)
		color=$GREEN
		;;
	*)
		color=$NC
		;;
	esac
	echo -e "${color}${text}${NC}" >&2
}

purge $1
