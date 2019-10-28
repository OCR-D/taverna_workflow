FROM ocrd/tesserocr:edge

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONIOENCODING utf8

####################################################
# Install dependencies for taverna                 #
####################################################
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
# apt-get install -y --no-install-recommends \     #
#       libtesseract-dev \                         #
#       libleptonica-dev \                         #
#       tesseract-ocr-eng \                        #
#       tesseract-ocr; \                           #
####################################################
#   apt-get -y install --no-install-recommends \
#       libtesseract-dev \
#       libleptonica-dev \
#       tesseract-ocr-eng \
#       tesseract-ocr; \
####################################################
# End installation additional packages.            #
####################################################
    apt-get clean; \
    rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

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

####################################################
# Prepare environment for workflow                 #
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

