#!/bin/bash
echo '#! /bin/sh' >/usr/bin/mesg
chmod 755 /usr/bin/mesg
service ssh start

formatNamenode() {
    hdfs namenode -format
}
genKey() {
    if [ ! -f /root/.ssh/id_rsa ]; then
        ssh-keygen -P "" -f ~/.ssh/id_rsa
        cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
    fi
}
startAll() {
    genKey
    /usr/bin/bd/hadoop/hadoop-3.1.4/sbin/start-dfs.sh
    /usr/bin/bd/spark/spark-3.1.1-bin-hadoop2.7/sbin/start-master.sh
    spark-class org.apache.spark.deploy.worker.Worker "spark://$(hostname):7077"
}

if [ -d "/usr/bin/bd/fs/data/hadoop/nameNode" ]; then
    startAll
else
    formatNamenode
    startAll
fi

lsof -i -P -n | grep LISTEN
