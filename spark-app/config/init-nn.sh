#!/bin/bash

service sshd start

rm -rf /tmp/hadoop-root/dfs/data/*

/usr/local/hadoop/bin/hdfs namenode -format
/usr/local/hadoop/sbin/start-dfs.sh
/usr/local/hadoop/sbin/start-yarn.sh
#/usr/local/hadoop/sbin/hadoop-daemon.sh start datanode
#/usr/local/hadoop/sbin/yarn-daemon.sh start resourcemanager
#/usr/local/hadoop/sbin/yarn-daemon.sh start nodemanager

cd ~ && /bin/bash
