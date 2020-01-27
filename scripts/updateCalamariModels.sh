#!/bin/bash
# Create/Update calamari models

# Test for commands used in this script
testForCommands="wget tar"

for command in $testForCommands
do 
  $command --help >> /dev/null
  if [ $? -ne 0 ]; then
    echo "Error: command '$command' is not installed!"
    exit 1
  fi
done

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
#### Copy models for calamari
####################################################
mkdir -p "$INSTALLATION_DIRECTORY"/models/calamari/GT4HistOCR
cd "$INSTALLATION_DIRECTORY"/models/calamari/GT4HistOCR
wget https://ocr-d-repo.scc.kit.edu/models/calamari/GT4HistOCR/model.tar.xz
tar xf model.tar.xz
rm model.tar.xz

