#!/bin/bash
# Create/Update taverna cli
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
  echo   $0 /path/to/model
  exit 1
fi

INSTALLATION_DIRECTORY=$(readlink -f $1)

# Check if directory exists
if [ ! -d "$INSTALLATION_DIRECTORY" ]; then
  # Create directory if it doesn't exists.
  mkdir -p "$INSTALLATION_DIRECTORY"
fi

####################################################
# Prepare taverna for workflow                     #
####################################################
# Download taverna cli to temp dir
TEMP_DIR=$(mktemp -d -t taverna-cli-XXXX)
cd $TEMP_DIR
wget https://bitbucket.org/taverna/taverna-commandline-product/downloads/taverna-commandline-core-2.5.0-standalone.zip
# Check checksum
sha1sum -c "$ACTUAL_DIR"/sha1sum.txt
# copy to installation dir
cd "$INSTALLATION_DIRECTORY"
unzip $TEMP_DIR/taverna-commandline-core-2.5.0-standalone.zip 
# cleanup
rm -rf $TEMP_DIR

###########################################################################
# Install jar dependencies for workflow
###########################################################################
# add external libraries with gradle.
cd "$ACTUAL_DIR"/..
./gradlew copyDependencies
mv  externalLibs/* "$INSTALLATION_DIRECTORY"/taverna-commandline-core-2.5.0/lib/




