# OCR-D workflow for Taverna using Docker

## Hardware Requirements
At least 10GB of free disk space is recommended.
Only the installation of all processors requires up to 7GB of disc space.

## Prerequisites
- Docker ([Installation Docker](installDocker.md))
- Docker container holding all processors ([see GitHub to see how it is created](https://github.com/OCR-D/ocrd_all)) or try 'docker pull ocrd/all'.

## Build Docker Image
```bash=bash
user@localhost:~$cd ~/Downloads
user@localhost:~/Downloads$mkdir taverna
user@localhost:~/Downloads$cd taverna/
user@localhost:~/Downloads/taverna$wget https://raw.githubusercontent.com/OCR-D/taverna_workflow/master/Dockerfile
user@localhost:~/Downloads/taverna$docker build -t ocrd/taverna .
[...]
Successfully tagged ocrd/taverna
user@localhost:~/Downloads/taverna$
```

## Create Directory for all configuration files and documents 
Create a directory where you can store all documents. There should be at least 
500 MB of free disc space left.
```bash=bash
user@localhost:~$mkdir -p ocrd/taverna
user@localhost:~$cd ocrd/taverna/
user@localhost:~/ocrd/taverna$
```

## Initialize Workflow
 
```bash=bash
user@localhost:~/ocrd/taverna$docker run -v 'pwd':/data ocrd/taverna init
[...]
Now you can start workflow by executing 'docker run --network="host" -v /taverna/git:/data dockerimage process
user@localhost:~/ocrd/taverna$
```
## First Test
To check if the installation works fine you can start a first test.
```bash=bash
user@localhost:~/ocrd/taverna$docker run --network="host" -v 'pwd':/data ocrd/taverna testWorkflow
[...]
Outputs will be saved to the directory: /taverna/git/Execute_OCR_D_workfl_output
# The processed workspace should look like this:
user@localhost:~/ocrd/taverna$ls -1 workspace/example/data/
metadata
mets.xml
OCR-D-GT-SEG-BLOCK
OCR-D-GT-SEG-PAGE
OCR-D-IMG
OCR-D-IMG-BIN
OCR-D-IMG-BIN-OCROPY
OCR-D-OCR-CALAMARI_GT4HIST
OCR-D-OCR-TESSEROCR-BOTH
OCR-D-OCR-TESSEROCR-FRAKTUR
OCR-D-OCR-TESSEROCR-GT4HISTOCR
OCR-D-SEG-LINE
OCR-D-SEG-REGION
```
Each sub folder starting with 'OCR-D-OCR' should now
contain 4 files with the detected full text.

### The metadata sub directory
The subdirectory 'metadata' contains the provenance of the workflow all
intermediate mets files and the stdout and stderr output of all executed processors.

## Create your own workflow
See instructions in ../README.md.

:information_source: All provided paths inside the parameter and workflow configuration files have to be 'dockerized'. For executing scripts relative paths are also possible. 

The commands should look like this:
### Test Processors
For a fast test if a processor is available try the following command:
```bash=bash
# Test if processor is installed e.g. ocrd-cis-ocropy-binarize
user@localhost:~/ocrd/taverna$docker run -v 'pwd':/data ocrd/taverna dump ocrd-cis-ocropy-binarize
{
 "executable": "ocrd-cis-ocropy-binarize",
 "categories": [
  "Image preprocessing"
 ],
 "steps": [
  "preprocessing/optimization/binarization",
  "preprocessing/optimization/grayscale_normalization",
  "preprocessing/optimization/deskewing"
 ],
 "input_file_grp": [
  "OCR-D-IMG",
  "OCR-D-SEG-BLOCK",
  "OCR-D-SEG-LINE"
 ],
 "output_file_grp": [
  "OCR-D-IMG-BIN",
  "OCR-D-SEG-BLOCK",
  "OCR-D-SEG-LINE"
 ],
 "description": "Binarize (and optionally deskew/despeckle) pages / regions / lines with ocropy",
 "parameters": {
  "method": {
   "type": "string",
   "enum": [
    "none",
    "global",
    "otsu",
    "gauss-otsu",
    "ocropy"
   ],
   "description": "binarization method to use (only ocropy will include deskewing)",
   "default": "ocropy"
  },
  "grayscale": {
   "type": "boolean",
   "description": "for the ocropy method, produce grayscale-normalized instead of thresholded image",
   "default": false
  },
  "maxskew": {
   "type": "number",
   "description": "modulus of maximum skewing angle to detect (larger will be slower, 0 will deactivate deskewing)",
   "default": 0.0
  },
  "noise_maxsize": {
   "type": "number",
   "description": "maximum pixel number for connected components to regard as noise (0 will deactivate denoising)",
   "default": 0
  },
  "level-of-operation": {
   "type": "string",
   "enum": [
    "page",
    "region",
    "line"
   ],
   "description": "PAGE XML hierarchy level granularity to annotate images for",
   "default": "page"
  }
 }
}
user@localhost:~/ocrd/taverna$
```

### Execute your own Workflow
If workflow is configured it can be started.
```bash=bash
user@localhost:~/ocrd/taverna$docker run --network="host" -v 'pwd':/data ocrd/taverna process my_parameters.txt relative/path/to/workspace/containing/mets
```



## More Information

* [Docker](https://www.docker.com/)

