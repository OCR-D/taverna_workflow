# OCR-D workflow for Taverna using Docker

## Prerequisites

In order to execute a workflow you'll need:
- [Java](https://java.com/download) 7 or higher 
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

### Make Document accessible for Docker
All files located in 'dockerfiles' are available inside the docker container
via the path /workspace. To make the document 'visible' for the workflow the
mets.xml and the referenced files have to be copied to /path/to/docker/dockerfiles.

:heavy_exclamation_mark: Therefor all local paths inside the configuration files have to be replaced by ***/workspace***. :heavy_exclamation_mark:

E.g.: ***/path/to/docker/dockerfiles***/workspace1/mets.xml --> ***/workspace***/workspace1/mets.xml

## Execute Workflow
If workflow is configured it can be started.
```bash=bash
user@localhost:/path/to/docker/$sudo docker run -v "$(pwd)"/dockerfiles:/workspace taverna:ocrd
[...]
```

## Test workflow
To test the workflow, follow the steps below.
```bash=bash
user@localhost:~$mkdir testTaverna
user@localhost:~$cd testTaverna
user@localhost:~/testTaverna$ wget https://github.com/OCR-D/taverna_workflow/archive/master.zip
user@localhost:~/testTaverna$ unzip master.zip
user@localhost:~/testTaverna$ cd taverna_workflow-master/installDocker/
user@localhost:~/testTaverna/taverna_workflow-master/installDocker$ bash prepareDocker.sh /tmp/tavernaWorkflow
user@localhost:~/testTaverna/taverna_workflow-master/installDocker$ cd /tmp/tavernaWorkflow
user@localhost:/tmp/tavernaWorkflow$sudo docker build -t taverna:ocrd .
user@localhost:/tmp/tavernaWorkflow$cd dockerfiles
user@localhost:/tmp/tavernaWorkflow/dockerfiles$mkdir workspace1
user@localhost:/tmp/tavernaWorkflow/dockerfiles$cd workspace1
user@localhost:/tmp/tavernaWorkflow/dockerfiles/workspace1$wget 'https://ocr-d-repo.scc.kit.edu/api/v1/dataresources/736a2f9a-92c6-4fe3-a457-edfa3eab1fe3/data/wundt_grundriss_1896.ocrd.zip'
user@localhost:/tmp/tavernaWorkflow/dockerfiles/workspace1$unzip wundt_grundriss_1896.ocrd.zip
user@localhost:/tmp/tavernaWorkflow/dockerfiles/workspace1$cd ../..
user@localhost:/tmp/tavernaWorkflow$sudo docker run -v "$(pwd)"/dockerfiles:/workspace taverna:ocrd
[...]
```
As a result of the workflow a bagit-Container will be created at '/tmp/tavernaWorkflow/dockerfiles/workspace1/data'. The provenance metadata and the (error) output of the processes will be available at '/tmp/tavernaWorkflow/dockerfiles/workspace1/data/metadata'

## More Information

* [Docker](https://www.docker.com/)
* [Taverna Commandline Tool](http://www.taverna.org.uk/download/command-line-tool/)

