FROM openjdk:8-jdk-alpine
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
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
CP workflow/externalLibs/* taverna-commandline-core-2.5.0/lib
WORKDIR /workspace/workflow
ENTRYPOINT ["sh", "-c", "sh /workspace/workflow/startWorkflow.sh"]

