#!/bin/bash
# Directories:
# $INSTALLATION_DIR - files for executing taverna workflow
#                  startWorkflow.sh
# $INSTALLATION_DIR/workspace  - workspaces should be placed here
## $INSTALLATION_DIR/conf - configuration files
#                  workflow_configuration*.txt
#                  parameters*.txt
# $INSTALLATION_DIR/workflow/taverna - taverna workflow
#    Execute_OCR-D_workflow.t2flow
###########################################################################
# Test for commands used in this script and scripts called
###########################################################################
testForCommands="git sha1sum tar unzip wget"

for command in $testForCommands
do 
  $command --help >> /dev/null
  if [ $? -ne 0 ]; then
    echo "Error: command '$command' is not installed!"
    exit 1
  fi
done
# Separate test for 'java' due to parameter '--help' doesn't exist
java -version
if [ $? -ne 0 ]; then
  echo "Error: command 'java' is not installed!"
  exit 1
fi

###########################################################################
# Check argument
###########################################################################
# Determine directory of script. 
ACTUAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# Check if argument is given
if [ -z "$1" ]; then
  echo Please provide a directory where to install.
  echo USAGE:
  echo   $0 /path/to/docker
  exit 1
fi

INSTALLATION_DIRECTORY=$(readlink -f $1)

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
echo Install taverna workflow into "$INSTALLATION_DIRECTORY"
# Copy taverna configuration files
cp -R conf "$INSTALLATION_DIRECTORY"

# Replace {INSTALLATION_DIR} by INSTALLATION_DIRECTORY. 
REPLACE_STRING=${INSTALLATION_DIRECTORY//\//\\\/}
for paramFile in "$INSTALLATION_DIRECTORY"/conf/*.txt; do
  sed -i -e 's/{INSTALLATION_DIR}/'"$REPLACE_STRING"'/g' $paramFile
done


# Copy taverna workflow
bash scripts/updateTavernaWorkflow.sh "$INSTALLATION_DIRECTORY"

# Create taverna cli
bash scripts/installTavernaCli.sh "$INSTALLATION_DIRECTORY"

# Create calamari models
bash scripts/updateCalamariModels.sh "$INSTALLATION_DIRECTORY"

# Create calamari parameter files
bash scripts/updateCalamariParameterfiles.sh "$INSTALLATION_DIRECTORY"

# Create example workspace for first tests
bash scripts/updateExampleWorkspace.sh "$INSTALLATION_DIRECTORY"

# Create tesseract models
bash scripts/updateTesseractModels.sh "$INSTALLATION_DIRECTORY"

# Create tesseract parameter files
bash scripts/updateTesseractParameterfiles.sh "$INSTALLATION_DIRECTORY"

# Download and 'install' model file for segmentation for DFKI
bash scripts/updateDfkiModels.sh "$INSTALLATION_DIRECTORY"

# Download and 'install' model file for pixel classification of JMU Würzburg
bash scripts/updatePixelClassifierModels.sh "$INSTALLATION_DIRECTORY"

# Download and 'install' model file and 'profiler' of CIS München
bash scripts/updateCisModels.sh "$INSTALLATION_DIRECTORY"

# Copy start script to installation directory
cp "$ACTUAL_DIR"/startWorkflow.sh "$INSTALLATION_DIRECTORY"

echo SUCCESS
echo Now you have to edit the configurations files found in "$INSTALLATION_DIRECTORY"/conf.
echo To start workflow without parameters please configure "$INSTALLATION_DIRECTORY"/conf/workflow_configuration.txt
echo and "$INSTALLATION_DIRECTORY"/conf/parameters.txt.
echo Make sure that all modules used by the workflow are installed.

