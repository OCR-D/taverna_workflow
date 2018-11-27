# OCR-D workflow for Taverna

To develop or edit the workflows it's recommended to use Taverna Workbench Core 2.5 (see 
requirements).

## Requirements

- [Python 3.X](https://www.python.org/downloads/)
- [Taverna Command Line Tool 2.5](http://www.taverna.org.uk/download/command-line-tool/2-5/core)
or 
- [Taverna Workbench Core 2.5](http://www.taverna.org.uk/download/workbench/2-5/core/) (Only for development)

## First steps to execute workflow
### Install OCR-D core
```shell=shell
user@localhost:/home/user$ sudo pip3 install ocrd
Successfully installed...
```
### Install Module Projects
e.g.: [https://github.com/OCR-D/ocrd_kraken](https://github.com/OCR-D/ocrd_kraken)

### Install Taverna Workbench or Command Line Tool
Download the appropriate package.(e.g. taverna-....-linux_amd64.deb)
```shell=shell
user@localhost:/home/user$ sudo apt install /path/to/package/taverna-...-linux_amd64.deb
Successfully installed...
```

### Configure Workflow
Before a workflow can be started, it must be configured first.
An example will be available at conf/workflow_configuration.txt
#### Download Workflow Configuration Template and Workflow
```shell=shell
user@localhost:/home/user$ mkdir workflow
user@localhost:/home/user/workflow$ wget https://raw.githubusercontent.com/OCR-D/taverna_workflow/master/conf/workflow_configuration.txt
user@localhost:/home/user/workflow$ wget https://raw.githubusercontent.com/OCR-D/taverna_workflow/master/taverna/Execute_OCR-D_workflow.t2flow
```

:information_source: All commands listed in the workflow must be executable in the command line.

### Execute Workflow
```shell=shell
user@localhost:/home/user/workflow$ executeworkflow -inputvalue mets_file_url file:///path/to/file/mets.xml -inputvalue workflow_configuration_file file:///home/ocrd/workflow/workflow_configuration.txt Execute_OCR-D_workflow.t2flow
