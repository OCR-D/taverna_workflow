#!/bin/bash
# Directories:
# $INSTALLATION_DIR - files for dockerizing 
# $INSTALLATION_DIR/dockerfiles  - workspace
#   mets.xml
#   digitalized pages
## $INSTALLATION_DIR/dockerfiles/workflow - configuration files and start script
#    workflow_configuration
#    parameters.txt
#    startWorkflow.sh
# $INSTALLATION_DIR/dockerfiles/workflow/taverna - taverna workflow
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
  echo   prepareDocker.sh /path/to/docker
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
echo Install taverna workflow for Docker into $INSTALLATION_DIRECTORY

###########################################################################
# Install jar dependencies for workflow
###########################################################################
# add external libraries with gradle.
cd "$ACTUAL_DIR"/..
./gradlew copyDependencies

cd "$INSTALLATION_DIRECTORY"

###########################################################################
# Install workflow scripts and configuration files
###########################################################################
# Create directories
mkdir -p "$INSTALLATION_DIRECTORY"/dockerfiles/workflow/taverna
# Copy start script and config files to installation directory
cp "$ACTUAL_DIR"/workflow/* "$INSTALLATION_DIRECTORY"

# Copy start script and config files to installation directory
cp "$ACTUAL_DIR"/workflow/workflow/* "$INSTALLATION_DIRECTORY"/dockerfiles/workflow

# Copy external jar and config files to installation directory
cp -r "$ACTUAL_DIR"/workflow/externalLibs "$INSTALLATION_DIRECTORY"/dockerfiles/workflow

# Copy workflow to installation directory
cp "$ACTUAL_DIR"/../taverna/Execute_OCR-D_workflow.t2flow "$INSTALLATION_DIRECTORY"/dockerfiles/workflow/taverna

echo SUCCESS
echo Now you have to adapt the "$INSTALLATION_DIRECTORY"/Dockerfile.
echo To start workflow please configure "$INSTALLATION_DIRECTORY"/dockerfiles/workflow/workflow_configuration.txt
echo and "$INSTALLATION_DIRECTORY"/dockerfiles/workflow/parameters.txt.
echo Make sure that all modules used by the workflow are installed.
echo Then build an image. \('sudo docker build -t taverna:ocrd .'\)
echo At the end start workflow by executing 'sudo docker run -v "$(pwd)"/dockerfiles:/workspace taverna:ocrd' 

