# OCR-D workflow for Taverna using Docker

## Prerequisites

In order to execute a workflow you'll need:
- Docker ([Installation Docker](installDocker.md))

## Prepare Docker Environment
To prepare the environment for docker execute shell script:
```bash=bash
user@localhost:/home/user/taverna_workflow$bash installDocker/prepareDocker.sh /path/to/docker
```
:information_source: The path must not contain spaces or special characters.

## Adapt Dockerfile (Install Modules)
Please refer to the documentation of the modules you want to install.
Adapt the Dockerfile accordingly
```bash=bash
user@localhost:/home/user/taverna_workflow$cd /path/to/docker
user@localhost:/path/to/docker$gedit Dockerfile
```

## Build Docker Image
```bash=bash
user@localhost:/path/to/docker$sudo docker build -t taverna:ocrd .
[...]
Successfully tagged taverna:ocrd
user@localhost:/path/to/docker$
```

## Configure Workflow
Before a workflow can be started, it must be configured first.
Please adapt the configuration files due to your needs.
Files to edit:
* /path/to/docker/dockerfiles/workflow/parameters.txt
* /path/to/docker/dockerfiles/workflow/workflow_configuration.txt

(See examples inside the files)

:information_source: Make sure that all modules used by the workflow are installed.

## Execute Workflow
If workflow is configured it can be started.
```bash=bash
user@localhost:/path/to/docker/$sudo docker run taverna:ocrdbash /path/to/workflow/workflow/startWorkflow.sh
[...]
```

## More Information

* [Docker](https://www.docker.com/)
* [Taverna Commandline Tool](http://www.taverna.org.uk/download/command-line-tool/)

