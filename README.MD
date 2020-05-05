# OCR-D workflow for Taverna

To develop or edit the workflows it's recommended to use Taverna Workbench Core 2.5 (see 
requirements). For executing workflow the taverna commandline tool is sufficient.

## Requirements

- [Java](https://java.com/download) **7 or 8** (Ubuntu: 'sudo apt-get install openjdk-8-jdk') (will at least not work with java 11)
- [Git](https://git-scm.com/downloads)
- Processors ([check GitHub to see how they are created](https://github.com/OCR-D/ocrd_all))


## Installation 
### Installation using Docker
The OCR-D workflow and all processors may be also exectued inside a docker container.
Please refer to [OCR-D workflow for Taverna using Docker](installDocker/installation.md)

### Local Installation
#### Install Processors
First all needed processors should be installed.
Please refer to [GitHub](https://github.com/OCR-D/ocrd_all) 

#### Checkout Taverna OCR-D Workflow via GitHub
```bash=bash
user@localhost:~$mkdir git
user@localhost:~$cd git
user@localhost:~/git$git clone https://github.com/OCR-D/taverna_workflow.git
user@localhost:~/git$cd taverna_workflow/
user@localhost:~/git/taverna_workflow$
```

## Create Directory for all configuration files and documents 
Create a directory where you can store all documents. There should be at least 
500 MB of free disc space left. 
After that install taverna workflow into the created directory.
```bash=bash
user@localhost:~$mkdir -p ~/ocrd/taverna
user@localhost:~$cd ~/git/taverna_workflow/
user@localhost:~/git/taverna$bash installTaverna.sh ~/ocrd/taverna
```
#### First Test of OCR-D Workflow
To check if the installation works fine you can start a first test.
```bash=bash
user@localhost:~$cd ~/ocrd/taverna
user@localhost:~/ocrd/taverna$bash startWorkflow.sh parameters_all.txt
[...]
Outputs will be saved to the directory: /.../Execute_OCR_D_workfl_output
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
##### The metadata sub directory
The subdirectory 'metadata' contains the provenance of the workflow all
intermediate mets files and the stdout and stderr output of all executed processors.

## Test your own Documents
If you want to test this workflow with your own documents you have
to pass the workspace directory with a mets.xml inside to the shell script.
```bash=bash
user@localhost:~$cd ~/ocrd/taverna
user@localhost:~/ocrd/taverna$bash startWorkflow.sh parameters_all.txt /path/to/workspace/containing/mets
```

## Configure your own Workflow
Before a [workflow](https://ocr-d.de/en/workflows) can be started, it must be configured first.
```bash=bash
# Make a copy of a parameters and a workflow configuration
user@localhost:~/ocrd/taverna$cp conf/parameters_all.txt conf/my_parameters.txt
user@localhost:~/ocrd/taverna$cp conf/workflow_configuration_all.txt conf/my_workflow_configuration.txt
```
Now adapt the configuration files due to your needs.
(See examples inside the files)

:information_source: Make sure that all processors used by the workflow are installed.


### Test Processors
For a fast test if a processor is available try the following command:
```bash=bash
# Test if processor is installed e.g. ocrd-cis-ocropy-binarize
user@localhost:~/ocrd/taverna$ocrd-cis-ocropy-binarize -J
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
user@localhost:~/ocrd/taverna$bash startWorkflow.sh my_parameters.txt /path/to/workspace/containing/mets
```

## More Information

* [Workflow for OCR-D](https://ocr-d.de/en/workflows)
* [Taverna](https://taverna.incubator.apache.org/)
* [Taverna Commandline Tool](http://www.taverna.org.uk/download/command-line-tool/)


