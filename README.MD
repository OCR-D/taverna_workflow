# OCR-D workflow for Taverna

To develop or edit the workflows it's recommended to use Taverna Workbench Core 2.5 (see 
requirements). For executing workflow the taverna commandline tool is sufficient.

## Requirements

- [Java](https://java.com/download) 7 or higher 
- [Python 3.X](https://www.python.org/downloads/)
- [Taverna Workbench Core 2.5](http://www.taverna.org.uk/download/workbench/2-5/core/)
- or [Taverna Commandline Tool 2.5](http://www.taverna.org.uk/download/command-line-tool/) (alternatively)

## Installation 
### Installation using Docker
The OCR-D workflow may be also exectued inside a docker container.
Please refer to [OCR-D workflow for Taverna using Docker](installDocker/installation.md)

### Install OCR-D core
```bash=bash
user@localhost:/home/user/$pip3 install ocrd
```
### Install OCR-D Workflow / Taverna Commandline Tool
```bash=bash
user@localhost:/home/user/$wget https://github.com/OCR-D/taverna_workflow/archive/master.zip
user@localhost:/home/user/$unzip master.zip
user@localhost:/home/user/$cd taverna_workflow-master/
user@localhost:/home/user/$bash installDocker/workflow/installWorkflowEngine.sh /path/to/workflow
```
:information_source: The path must not contain spaces or special characters.

## Install Modules
Please refer to the documentation of the modules you want to install.

## Configure Workflow
Before a workflow can be started, it must be configured first.
Please adapt the configuration files due to your needs.
Files to edit:
* /path/to/workflow/workflow/parameters.txt
* /path/to/workflow/workflow/workflow_configuration.txt

(See examples inside the files)

:information_source: Make sure that all modules used by the workflow are installed.
At the end start workflow by executing 

## Execute Workflow
If workflow is configured it can be started.
```bash=bash
user@localhost:/home/user/$bash /path/to/workflow/workflow/startWorkflow.sh
```

## More Information

* [Taverna](https://taverna.incubator.apache.org/)
* [Taverna Commandline Tool](http://www.taverna.org.uk/download/command-line-tool/)


