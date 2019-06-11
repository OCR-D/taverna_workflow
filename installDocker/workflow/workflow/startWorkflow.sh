#!/bin/bash

# Determine directory of script. 
ACTUAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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
done < "$ACTUAL_DIR"/parameters.txt

# Start workflow
bash "/usr/local/taverna/taverna-commandline-core-2.5.0/executeworkflow.sh" -inputvalue working_dir "$WORKING_DIR" -inputvalue workflow_configuration_file "$WORKFLOW_CONFIG_FILE" -inputvalue mets_file_url "$METS" -inputvalue unique_prefix_for_provenance "$PREFIX_PROV" "$ACTUAL_DIR"/taverna/Execute_OCR-D_workflow.t2flow 
