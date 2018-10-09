#
# docker build -t mvn-jdk8:1.0 .
#

FROM maven:3.5.4-jdk-8

ADD get-docker.sh /get-docker.sh
# RUN curl https://get.docker.com -o get-docker.sh \

RUN sh get-docker.sh --mirror Aliyun \
    && apt-get update \
    && apt-get install sshpass \