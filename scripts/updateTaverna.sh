#!/bin/bash

# Test for commands used in this script
testForCommands="git"

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
  echo Please provide the git directory of taverna_workflow.
  echo USAGE:
  echo   $0 /path/to/git/repo
  exit 1
fi

INSTALLATION_DIRECTORY=$(readlink -f $1)
# Check if directory exists
if [ ! -d "$INSTALLATION_DIRECTORY"/.git ]; then
  echo "$INSTALLATION_DIRECTORY" is not a valid git repo.
  echo USAGE:
  echo   $0 /path/to/git/repo
  exit 1
fi

case "${1}" in

	*)
           cd "$INSTALLATION_DIRECTORY"
           git pull origin
esac

exit 0

