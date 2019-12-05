#!/bin/bash
# Create/Update taverna workflow
# $INSTALLATION_DIR/workflow/taverna - taverna workflow
#    Execute_OCR-D_workflow.t2flow

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
#### Install taverna workflow
####################################################
mkdir -p "$INSTALLATION_DIRECTORY"/workflow/taverna
cp "$ACTUAL_DIR"/../taverna/Execute_OCR-D_workflow.t2flow "$INSTALLATION_DIRECTORY"/workflow/taverna

