# Define the colors for the log messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

log() {
    printf "${GREEN}$1${NC}\n"
}

error() {
    printf "\n${RED}ERROR: $1${NC}\n"
}