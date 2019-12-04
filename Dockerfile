FROM ocrd/all:latest
MAINTAINER OCR-D
ENV DEBIAN_FRONTEND noninteractive

####################################################
# Requirements                                     #
####################################################
# Minimum 8GB RAM for building Container (tested with 16GB)

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
# /taverna Installation taverna cli                #
# /data/workflow config files for taverna workflow #
# /data/models  models for OCR                     #
####################################################
RUN mkdir -p /taverna
RUN mkdir -p /data
RUN mkdir -p /ocrd/workspace/example
RUN mkdir -p /ocrd/models/tesseract/GT4HistOCR
RUN mkdir -p /ocrd/models/calamari/GT4HistOCR
RUN mkdir -p /tmp/git

####################################################
#### Copy models from calamari
####################################################
WORKDIR /ocrd/models/calamari/GT4HistOCR
RUN wget https://file.spk-berlin.de:8443/calamari-models/GT4HistOCR/model.tar.xz; tar xf model.tar.xz; rm model.tar.xz

####################################################
#### Copy models from tesseract
####################################################
WORKDIR /ocrd/models/tesseract/GT4HistOCR
RUN wget https://ub-backup.bib.uni-mannheim.de/~stweil/ocrd-train/data/GT4HistOCR_5000000/tessdata_best/GT4HistOCR_50000000.997_191951.traineddata
RUN cp /usr/share/tesseract-ocr/4.00/tessdata/Fraktur.traineddata .
RUN wget 'https://github.com/tesseract-ocr/tessdata_best/raw/master/deu.traineddata'
RUN wget 'https://github.com/tesseract-ocr/tessdata_best/raw/master/eng.traineddata'
RUN export TESSDATA_PREFIX=/ocrd/models/tesseract/GT4HistOCR/

####################################################
#### Create parameter files for calamari
####################################################
RUN echo '{ "checkpoint": "/data/models/calamari/GT4HistOCR/*.ckpt.json" }' > /ocrd/models/param-calamari-gt4hist.json

####################################################
#### Create parameter files for tesseract
####################################################
RUN echo '{ "model": "Fraktur" }' > /ocrd/models/param-tess-fraktur.json
RUN echo '{ "model": "GT4HistOCR_50000000.997_191951" }' > /ocrd/models/param-tess-gt4hist.json
RUN echo '{ "model": "Fraktur+GT4HistOCR_50000000.997_191951" }' > /ocrd/models/param-tess-both.json

####################################################
#### Download taverna workflow
####################################################
WORKDIR /tmp/git
RUN wget https://github.com/OCR-D/taverna_workflow/archive/master.zip; unzip master.zip; rm master.zip
WORKDIR /tmp/git/taverna_workflow-master/installDocker
RUN sh prepareDocker.sh /tmp/docker

####################################################
# Prepare taverna for workflow                     #
####################################################
WORKDIR /tmp
RUN wget https://bitbucket.org/taverna/taverna-commandline-product/downloads/taverna-commandline-core-2.5.0-standalone.zip
RUN sha1sum -c /tmp/git/taverna_workflow-master/installDocker/workflow/sha1sum.txt
WORKDIR /usr/local/taverna
RUN unzip /tmp/taverna-commandline-core-2.5.0-standalone.zip 
RUN mv  /tmp/docker/dockerfiles/workflow/externalLibs/* taverna-commandline-core-2.5.0/lib/

####################################################
#### Download example data
####################################################
WORKDIR /ocrd/workspace/example
RUN wget 'https://ocr-d-repo.scc.kit.edu/api/v1/dataresources/736a2f9a-92c6-4fe3-a457-edfa3eab1fe3/data/wundt_grundriss_1896.ocrd.zip';unzip wundt_grundriss_1896.ocrd.zip; rm wundt_grundriss_1896.ocrd.zip

ENTRYPOINT ["sh", "/tmp/docker/dockerfiles/workflow/startWorkflowViaDocker.sh"]

