#!/bin/bash
# Create/Update models of DFKI

# Test for commands used in this script
testForCommands="wget unzip"

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
#### segmentation
####################################################
####################################################
#### Copy models for segmentation of DFKI
####################################################
mkdir -p "$INSTALLATION_DIRECTORY"/models/dfki/segmentation
cd "$INSTALLATION_DIRECTORY"/models/dfki/segmentation
wget  -O block_segmentation_weights.h5 https://cloud.dfki.de/owncloud/index.php/s/dgACCYzytxnb7Ey/download

####################################################
#### dewarping
####################################################
mkdir -p "$INSTALLATION_DIRECTORY"/tmp/dfki
mkdir -p "$INSTALLATION_DIRECTORY"/python/pix2pixHD/checkpoints
####################################################
#### Copy pix2pixHD
####################################################
cd "$INSTALLATION_DIRECTORY"/tmp/dfki
wget https://github.com/NVIDIA/pix2pixHD/archive/master.zip
unzip master.zip
cd pix2pixHD-master/
mv data models options util "$INSTALLATION_DIRECTORY"/python/pix2pixHD
cd ..
# clean up
rm -rf master.zip pix2pixHD-master/
####################################################
#### Copy model for dewarping
####################################################
cd "$INSTALLATION_DIRECTORY"/python/pix2pixHD/checkpoints
wget -O latest_net_G.pth https://cloud.dfki.de/owncloud/index.php/s/3zKza5sRfQB3ygy
# Model has to be available in checkpoints and in models directory.
cp latest_net_G.pth ../models

