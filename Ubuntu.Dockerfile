FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

COPY ./Ubuntu/sources.list /etc/apt/sources.list
COPY ./Ubuntu/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources

ENV TZ=Asia/Shanghai
RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8