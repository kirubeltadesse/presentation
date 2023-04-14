#! /bin/bash

source /etc/make/bin/notifyUser.sh
# Process the command line arguments to determine the folder and command

set -e # Exit immediately if a command exits with a non-zero status.

DIRECTOR_WORK=/reveal.js/content/
SCRIPTS_DIR=/etc/make/bin
MAKE_DIR=/etc/make

main() {
    case "$1" in
        version)
            version
            return
            ;;
        bash)
            exec /bin/bash
            return
            ;;
    esac

    [ -z "$2" ] && error "Missing folder argument" && exit 1
    FOLDER=$2

    #If the VERBOSE env var is set, otherwise it is suppressed
    [ -n "${VERBOSE}" ] && OUTPUT="/dev/stdout" || OUTPUT="/dev/null"

    case $1 in
        "build")
            build $FOLDER
            ;;
        "clean")
            clean $FOLDER
            ;;
        "test")
            test
            ;;
        "collect-top")
            collect-top $FOLDER
            ;;
        "run")
            run
            ;;
        "debug")
            debug
            ;;
        "package")
            package
            ;;
        "deploy")
            deploy
            ;;
    esac
}

build-deck() {
    setup $1
    make -f $MAKE_DIR/deck.mk -C $1 build > $OUTPUT
}

setup-deck() {
    local ASSETS=$1/build/assets

    log "Setting up deck $1 in $DIRECTOR_WORK"
    make -f $MAKE_DIR/deck.mk -C $1 build > $OUTPUT
}


setup() {
    local ASSETS=$1/build/assets
    log "setup top $1 comming assests $ASSETS "
    mkdir -p $1/build
    # BUG: PWD might be causing problems
    # TODO: what is assests why do we need it
    [[ -L $ASSETS ]] || ln -s /etc/make/assets $ASSETS 
}

setup-top() {
    local ASSETS=$1/build/assets
    log "Setting up $1"
    mkdir -p $1/build
    # BUG: PWD might be causing problems
    [[ -L $ASSETS ]] || ln -s /etc/make/assets $ASSETS 
}


build() {
    # Build the project
    log "Building project line 80 `pwd` entry.sh passing $1 and folder"
    $SCRIPTS_DIR/build-top.sh --folder "$1" build

    setup-top $1

    error "entry.sh top.mk $1 where is build/index.html comming from"
    make -f /workarea/top.mk -C $1 /workarea/build/assets/index.html > $OUTPUT

    # Copy the deck build folder
    $SCRIPTS_DIR/build-top.sh --folder "$1" collect
}

collect-top() {
    # Copy the deck build folder
    log "Collecting top-level build folder"
    /build-top.sh --folder "$1" collect
}

clean() {
    # Clean the project
    log "Cleaning project"
    /etc/make/build-top.sh --folder "$1" clean

    [ -d "$1/build" ] && rm -rf "$1/build" \
    && find $1/build -mindepth 1 -maxdepth 1 -type d -exec rm -r {} \;
}

# FIXME: make it work with the new build-top.sh
test() {
    # Test the project
    log "Testing project"
    /build-top.sh --folder "$1" test
}

# TODO: archive the top-level build folder to zip

main $@

