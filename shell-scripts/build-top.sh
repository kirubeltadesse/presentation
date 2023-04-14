#!/bin/bash

# This script builds the top-level project, which is the only project
# that has a config.yaml file in the root directory.  It is called by
# the build.sh script in the root directory.

source notifyUser.sh

main() {

    if [[ $# -ne 3 || "$1" != "--folder" ]]; then
        error "Usage: $0 --folder <folder>"
        exit 1
    fi

    FOLDER=$2

    # Validate the command
    case "$3" in
        "build" | "collect" ) #| "clean" | "test" | "run" | "debug" | "package" | "deploy")
            ;;
        *)
            error "Invalid command: $3. Must be one of: build, clean, test, run, debug, package, deploy"
            exit 1
            ;;
    esac

    find_decks # Find the decks defined in the config.yaml file as sub-folders

    if [ -z "$NOPARALLEL" ] ; then
            parallel $3
    else
            serial $3
    fi

    # if [ -z "NOPARALLEL"]; then 
    #     # Build the decks in parallel
    #     for deck in "${DECKS[@]}"; do
    #         (cd "$deck" && ./build.sh --folder "$FOLDER" "$3") &
    #     done
    #     wait
    # else
    #     # Build the decks sequentially
    #     for deck in "${DECKS[@]}"; do
    #         (cd "$deck" && ./build.sh --folder "$FOLDER" "$3")
    #     done
    # fi
}

find_decks() {
    # Find the decks defined in the config.yaml file as sub-folders
    DECKS=()
    while IFS= read -r -d $'\0'; do
        # if [[ "$line" =~ ^deck: ]]; then
        #     DECKS+=("${line#deck: }")
        # fi
        DECKS+=($(echo $REPLY | sed -e 's_^./__'))

        log "Found deck: $deck"

    # done < <(grep -E "^deck:" config.yaml)
    # done < <(grep -E "^deck:" config.yaml | sed -e 's/^deck: //')
    done < <(cd ${FOLDER}; find . -type f -name 'config.yaml' -printf '%h\0' )

    log "This is the directory we are in:  $(pwd)"

    log "Found decks: ${DECKS[@]} and ${DECKS}"
    
    if [ ${#DECKS[@]} -eq 0 ]; then
        error "No decks found in the ${FOLDER} folder"
        exit 1
    fi
}

serial() {
    log "Building decks sequentially"
    # Build the decks sequentially
    for deck in "${DECKS[@]}"; do
        $1 "$deck" || (error "Failed to $1 for deck ${deck}" && exit 1)
    done
}

parallel() {
    log "Building decks in parallel"
    local PID=()
    local EXIT_CODES=()

    error "this is the list of the docks: ${DECKS[@]}"

    # Build the decks in parallel
    for deck in "${DECKS[@]}"; do
        (
            $1 "$deck" 
        ) &
        PID+=($!) # Store the PID of the background process
    done

    # Wait for all the background processes to finish
    for pid in "${PID[@]}"; do
        wait $pid
        EXIT_CODES+=($?) # Store the exit code of the background process
    done

    # Check the exit codes of the background processes
    for i in ${!DECKS[@]}; do 
        if [ ${EXIT_CODES[$i]} -ne 0 ]; then
            error "Failed to $1 for deck ${DECKS[$i]}"
            exit 1
        fi
    done
}

build() {
    local DECK=$1

    log "Building deck $FOLDER/$DECK `pwd` "

    # Build the deck in its build folder 
    # If the make command fials exit out of the function with an error code
    # TODO: Add a --clean flag to the build.sh script to clean the build folder
    # BUG: it is not getting the entry.sh 
    ./entry.sh build-deck $FOLDER/$DECK || exit $? 
}

collect() {
    local DECK=$1
    local DEST="${FOLDER}/build/${DECK}"

    log "Collecting slides from ${FOLDER}/${DECK}"

    mkdir -p ${DEST}
    cp -r ${FOLDER}/${DECK}/build/*.html ${DEST}/
    [ ! -e ${DEST}/assets ] && ln -s ../../${DECK}/build/assets ${DEST}/assets

    # if the build contains images/css, copy them to the build folder
    [ -e ${FOLDER}/${DECK}/build/imgs ] && cp -r ${FOLDER}/${DECK}/build/imgs ${DEST}/ || : 
    [ -e ${FOLDER}/${DECK}/build/css ] && cp -r ${FOLDER}/${DECK}/build/css ${DEST}/ || : 
}

clean() {
    local DECK=$1

    log "Cleaning deck $FOLDER/$DECK"

    # Clean the deck in its build folder 
    # If the make command fials exit out of the function with an error code
    /entry.sh clean-deck $FOLDER/$DECK || exit $? 
}

purge() {
    local DECK=$1

    log "Purging deck $FOLDER/$DECK"

    # Purge the deck in its build folder 
    # If the make command fials exit out of the function with an error code
    /entry.sh purge-deck $FOLDER/$DECK || exit $? 
}


main "$@"




