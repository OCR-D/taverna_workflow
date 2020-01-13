#!/bin/bash
# Create/Update tesseract models

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
#### Copy models from tesseract
####################################################
mkdir -p "$INSTALLATION_DIRECTORY"/models/tesseract/GT4HistOCR
cd "$INSTALLATION_DIRECTORY"/models/tesseract/GT4HistOCR
wget https://ub-backup.bib.uni-mannheim.de/~stweil/ocrd-train/data/GT4HistOCR_5000000/tessdata_best/GT4HistOCR_50000000.997_191951.traineddata
cp /usr/share/tesseract-ocr/4.00/tessdata/Fraktur.traineddata .
wget 'https://github.com/tesseract-ocr/tessdata_best/raw/master/deu.traineddata'
wget 'https://github.com/tesseract-ocr/tessdata_best/raw/master/eng.traineddata'
wget 'https://github.com/tesseract-ocr/tessdata_best/raw/master/osd.traineddata'


