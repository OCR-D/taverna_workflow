FROM ubuntu:latest

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN set -e; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        software-properties-common; \
        apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-8-jdk; \
    apt-get install -y \
        wget unzip; \
####################################################
# Install additional packages here                 #
# e.g.                                             #
# apt-get install -y \                             #
#       libtesseract-dev tesseract-ocr; \          #
####################################################
#    apt-get install -y \
#        libtesseract-dev tesseract-ocr; \
####################################################
# End installation additional packages.            #
####################################################
    apt-get clean; \
    rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

RUN set -e; \
    apt-get update; \
    apt-get install -y python3 python3-pip python3-dev python3-virtualenv build-essential && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [ ! -e /usr/bin/python ]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    pip install ocrd==1.0.0b19
####################################################
# Install additional python libraries via pip here #
# e.g.                                             #
# RUN pip install ocrd_ocropy                      #
# RUN pip install ocrd_kraken                      #
####################################################
#RUN pip install ocrd_kraken 
#RUN pip install ocrd_ocropy 
####################################################
# End installation of additional python libraries  #
####################################################

RUN mkdir -p /workspace/workflow
RUN mkdir -p /usr/local/taverna
RUN mkdir -p /tmp
VOLUME /workspace
WORKDIR /workspace
COPY sha1sum.txt /tmp
WORKDIR /tmp
RUN wget https://bitbucket.org/taverna/taverna-commandline-product/downloads/taverna-commandline-core-2.5.0-standalone.zip
RUN sha1sum -c /tmp/sha1sum.txt
WORKDIR /usr/local/taverna
RUN unzip /tmp/taverna-commandline-core-2.5.0-standalone.zip 
COPY dockerfiles/workflow/externalLibs/* taverna-commandline-core-2.5.0/lib/
WORKDIR /workspace/workflow
ENTRYPOINT ["sh", "-c", "sh /workspace/workflow/startWorkflow.sh"]

