#!/bin/bash
# Directories:
# $INSTALLATION_DIR  - workspace
#   mets.xml
#   digitalized pages
# $INSTALLATION_DIR/taverna-commandline-core-2.5.0 - taverna command line utility
# $INSTALLATION_DIR/workflow - configuration files and start script
#    workflow_configuration.txt
#    parameters.txt
#    startWorkflow.sh
# $INSTALLATION_DIR/workflow/taverna - taverna workflow
#    Execute_OCR-D_workflow.t2flow

###########################################################################
# Check argument
###########################################################################
# Determine directory of script. 
ACTUAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# Check if argument is given
if [ -z "$1" ]; then
  echo Please provide a directory where to install.
  echo USAGE:
  echo   installWorkflowEngine.sh /path/to/workflow
  exit 1
fi

INSTALLATION_DIRECTORY=$1

# Check if directory exists
if [ ! -d "$INSTALLATION_DIRECTORY" ]; then
  # Create directory if it doesn't exists.
  mkdir -p "$INSTALLATION_DIRECTORY"
fi
# Check if directory is empty
if [ ! -z "$(ls -A "$INSTALLATION_DIRECTORY")" ]; then
   echo "Please provide an empty directory or a new directory!"
   #exit 1
fi
echo Install taverna workflow into $INSTALLATION_DIRECTORY

cd "$INSTALLATION_DIRECTORY"
###########################################################################
# Install Taverna Commandline Tool
###########################################################################
# Download Taverna Commandline Tool
wget https://bitbucket.org/taverna/taverna-commandline-product/downloads/taverna-commandline-core-2.5.0-standalone.zip

# Validate Checksum
sha1sum -c "$ACTUAL_DIR"/sha1sum.txt
if [ $? -eq 0 ]; then
   echo "Checksum is OK"
else
  echo "Checksum of zip did NOT match"
  exit 1
fi

unzip taverna-commandline-core-2.5.0-standalone.zip

rm taverna-commandline-core-2.5.0-standalone.zip

###########################################################################
# Install jar dependencies for workflow
###########################################################################
# add external libraries with gradle.
cd "$ACTUAL_DIR"/../..
./gradlew copyDependencies
cp "$ACTUAL_DIR"/externalLibs/* "$INSTALLATION_DIRECTORY"/taverna-commandline-core-2.5.0/lib
cd "$INSTALLATION_DIRECTORY"

###########################################################################
# Install workflow scripts and configuration files
###########################################################################
# Copy start script and config files to installation directory
cp -R "$ACTUAL_DIR"/workflow "$INSTALLATION_DIRECTORY"

# Copy workflow to installation directory
mkdir -p "$INSTALLATION_DIRECTORY"/workflow/taverna
cp "$ACTUAL_DIR"/../../taverna/Execute_OCR-D_workflow.t2flow "$INSTALLATION_DIRECTORY"/workflow/taverna

# Adapt paths in parameters.txt and in startWorkflow.sh
sed -i -e "s,/workspace,$INSTALLATION_DIRECTORY,g" "$INSTALLATION_DIRECTORY"/workflow/parameters.txt
sed -i -e "s,/usr/local/taverna,$INSTALLATION_DIRECTORY,g" "$INSTALLATION_DIRECTORY"/workflow/startWorkflow.sh

echo SUCCESS
echo Before starting workflow please configure 
echo "$INSTALLATION_DIRECTORY"/workflow/workflow_configuration.txt
echo and "$INSTALLATION_DIRECTORY"/workflow/parameters.txt.
echo Make sure that all modules used by the workflow are installed.
echo At the end start workflow by executing bash "$INSTALLATION_DIRECTORY"/workflow/startWorkflow.sh



