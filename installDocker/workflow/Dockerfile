FROM openjdk:8-jdk-alpine
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
WORKDIR /workspace/workflow
ENTRYPOINT ["sh", "-c", "/workspace/startWorkflow.sh"]

