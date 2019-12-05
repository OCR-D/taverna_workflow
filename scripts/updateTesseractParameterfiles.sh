#!/bin/bash
# Create/Update tesseract parameter files

# Determine directory of script. 
ACTUAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

###########################################################################
# Check argument
###########################################################################
# Check if argument is given
if [ -z "$1" ]; then
  echo Please provide a directory where to install.
  echo USAGE:
  echo   $0 /path/to/installation/dir
  exit 1
fi

INSTALLATION_DIRECTORY=$(readlink -f $1)

# Check if directory exists
if [ ! -d "$INSTALLATION_DIRECTORY" ]; then
  # Create directory if it doesn't exists.
  mkdir -p "$INSTALLATION_DIRECTORY"
fi

####################################################
#### Create parameter files for tesseract
####################################################
mkdir -p "$INSTALLATION_DIRECTORY"/models
echo '{ "model": "Fraktur" }' > "$INSTALLATION_DIRECTORY"/models/param-tess-fraktur.json
echo '{ "model": "GT4HistOCR_50000000.997_191951" }' > "$INSTALLATION_DIRECTORY"/models/param-tess-gt4hist.json
echo '{ "model": "Fraktur+GT4HistOCR_50000000.997_191951" }' > "$INSTALLATION_DIRECTORY"/models/param-tess-both.json

