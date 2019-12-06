#!/bin/bash

# Determine directory of script. 
ACTUAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

###########################################################################
# Check environment for tesseract
###########################################################################
if [ "$TESSDATA_PREFIX" = "" ]; then
  export TESSDATA_PREFIX="ACTUAL_DIR"/models/tesseract/GT4HistOCR/
fi

# Define parameter file
if [ "$1" = "" ]; then
  PARAMETER_FILE=parameters.txt
else
  PARAMETER_FILE=$1
fi

PARAMETER_FILE="$ACTUAL_DIR"/conf/$PARAMETER_FILE

# Test if parameter file exists
if test -f "$PARAMETER_FILE"; then
   echo Use parameter file $1
else 
   echo Parameter file "$1" not found
   echo Possible parameter files:
   echo `ls -1 "$ACTUAL_DIR"/conf`
   exit 1
fi

# Set environment variable to UTF-8
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

while IFS=: read -r key value
do
if [ "$key" = "METS" ]; then
  METS=$value
  echo $key = $METS
fi
if [ "$key" = "WORKING_DIR" ]; then
  WORKING_DIR=$value
  echo $key = $WORKING_DIR
fi
if [ "$key" = "WORKFLOW_CONFIG_FILE" ]; then
  WORKFLOW_CONFIG_FILE=$value
  echo $key = $WORKFLOW_CONFIG_FILE
fi
if [ "$key" = "PREFIX_PROV" ]; then
  PREFIX_PROV=$value
  echo $key = $PREFIX_PROV
fi
done < "$PARAMETER_FILE"

# Overwrite METS and WORKING_DIR if second argument is available
if [ ! "$2" = "" ]; then
  WORKING_DIR=$(readlink -f $2)
  METS=$WORKING_DIR/mets.xml
  echo Overwrite METS and WORKING_DIR
  echo METS = $METS
  echo WORKING_DIR = $WORKING_DIR
fi

# Start workflow
bash "$ACTUAL_DIR/taverna-commandline-core-2.5.0/executeworkflow.sh" -inputvalue working_dir "$WORKING_DIR" -inputvalue workflow_configuration_file "$WORKFLOW_CONFIG_FILE" -inputvalue mets_file_url "$METS" -inputvalue unique_prefix_for_provenance "$PREFIX_PROV" "$ACTUAL_DIR"/workflow/taverna/Execute_OCR-D_workflow.t2flow 
