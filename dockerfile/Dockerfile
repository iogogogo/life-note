#############################################################################
#
# Dockerfile for xxx
#
#############################################################################
#
# Build with:
# docker build -t xxx:1.0.0 .
#
#############################################################################
#
# Run with:
# docker run --rm -dit -p 8080:8080 --name xxx xxx:1.0.0
#
#############################################################################

FROM openjdk:8-jre-alpine

MAINTAINER tao.zeng <tao.zeng9@gmail.com>

ENV VERSION 1.0.0-SNAPSHOT

RUN echo "http://mirrors.aliyun.com/alpine/v3.6/main" > /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/v3.6/community" >> /etc/apk/repositories \
    && apk update upgrade \
    && apk add --no-cache procps unzip curl bash tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

ADD xxx-${VERSION}.zip /data/xxx-${VERSION}.zip

RUN unzip /data/xxx-${VERSION}.zip -d /data/xxx \
    && rm -rf /data/xxx-${VERSION}.zip \
    && sed -i '$d' /data/xxx/restart.sh \
    && echo "tail -f /dev/null" >> /data/xxx/restart.sh

VOLUME ["/data/xxx/logs"]

EXPOSE 8080

CMD ["/data/xxx/restart.sh"]