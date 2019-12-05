FROM ocrd/all:latest
MAINTAINER OCR-D
ENV DEBIAN_FRONTEND noninteractive

####################################################
# Requirements                                     #
####################################################

####################################################
# Install dependencies for taverna                 #
####################################################
RUN set -e; \
    apt-get update; \
    apt-get install -y software-properties-common; \
    apt-get install -y --no-install-recommends \
        tesseract-ocr-script-frak \
        openjdk-8-jdk; \
    apt-get install -y \
        wget unzip; \
    apt-get clean;

####################################################
# Prepare environment for workflow                 #
# /taverna/git Git repo of taverna_workflow        #
# /data/       Base directory of taverna workflow  #
# /data/workflow taverna workflow and config files #
# /data/models  models for OCR                     #
# /data/workspace should contain all workspaces    #
# /data/taverna-commandline-core-2.5.0 taverna cli #
####################################################
RUN mkdir -p /taverna
RUN mkdir -p /data

RUN mkdir -p /git
WORKDIR /git
RUN git clone https://github.com/OCR-D/taverna_workflow.git

RUN mv taverna_workflow /taverna/git

WORKDIR /taverna/git/docker/
ENTRYPOINT ["sh", "/taverna/git/docker/startWorkflowViaDocker.sh"]

