FROM ubuntu:18.04

LABEL org.opencontainers.image.source https://github.com/Wignesh/bd-env

RUN apt-get update && apt-get upgrade -y
RUN apt-get install curl wget openjdk-8-jre ssh lsof -y

RUN mkdir -p /usr/bin/bd/hadoop
RUN mkdir -p /usr/bin/bd/spark
RUN wget -qO- https://apachemirror.wuchna.com/hadoop/common/hadoop-3.1.4/hadoop-3.1.4.tar.gz | tar zxvf - -C /usr/bin/bd/hadoop
RUN wget -qO- https://mirrors.estointernet.in/apache/spark/spark-3.1.1/spark-3.1.1-bin-hadoop2.7.tgz | tar zxvf - -C /usr/bin/bd/spark

COPY core-site.xml /usr/bin/bd/hadoop/hadoop-3.1.4/etc/hadoop/
COPY hdfs-site.xml /usr/bin/bd/hadoop/hadoop-3.1.4/etc/hadoop/
COPY hadoop-env.sh /usr/bin/bd/hadoop/hadoop-3.1.4/etc/hadoop/
COPY entrypoint.sh /usr/bin/bd/
RUN  chmod 777 /usr/bin/bd/entrypoint.sh

ENV HADOOP=/usr/bin/bd/hadoop/hadoop-3.1.4/
ENV SPARK=/usr/bin/bd/spark/spark-3.1.1-bin-hadoop2.7/
ENV PATH="${HADOOP}/bin:${PATH}"
ENV PATH="${SPARK}/bin:${PATH}"

WORKDIR /usr/bin/bd

EXPOSE 8080 8081 9000 9864 9866 9867 9868 9870

ENTRYPOINT /usr/bin/bd/entrypoint.sh && /bin/bash