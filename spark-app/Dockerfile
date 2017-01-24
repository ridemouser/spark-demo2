FROM centos:centos6

RUN yum -y update;
RUN yum -y clean all;

# Install basic tools
RUN yum install -y  wget dialog curl sudo lsof vim axel telnet nano openssh-server openssh-clients bzip2 passwd tar bc git unzip

#Install Java
#RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel 

RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY config/config /root/.ssh/
RUN chmod 400 /root/.ssh/config
COPY config/start.sh /root/
#COPY config/sync-hosts.sh /root/

# java
RUN \
  curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.rpm' -H 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie' && \
  rpm -i jdk-7u75-linux-x64.rpm && \
  rm jdk-7u75-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
RUN echo 'JAVA_HOME="/usr/java/default"' >> /etc/environment

# hadoop
RUN \
  cd /usr/local && curl -LO http://www.us.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz && \
  tar -xzf hadoop-2.7.3.tar.gz && \
  ln -s ./hadoop-2.7.3 hadoop && \
  rm hadoop-2.7.3.tar.gz

ENV HADOOP_PREFIX /usr/local/hadoop
ENV YARN_CONF_DIR /usr/local/hadoop/etc/hadoop
RUN \
  echo 'HADOOP_PREFIX="/usr/local/hadoop"' >> /etc/environment && \
  echo 'HADOOP_COMMON_HOME="/usr/local/hadoop"' >> /etc/environment && \
  echo 'HADOOP_HDFS_HOME="/usr/local/hadoop"' >> /etc/environment && \
  echo 'HADOOP_MAPRED_HOME="/usr/local/hadoop"' >> /etc/environment && \
  echo 'HADOOP_YARN_HOME="/usr/local/hadoop"' >> /etc/environment && \
  echo 'HADOOP_CONF_DIR="/usr/local/hadoop/etc/hadoop"' >> /etc/environment && \
  echo 'YARN_CONF_DIR="/usr/local/hadoop/etc/hadoop"' >> /etc/environment

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/java/default\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

COPY config/core-site.xml $HADOOP_PREFIX/etc/hadoop/
COPY config/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/
COPY config/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/
COPY config/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/

RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
COPY config/init-nn.sh /root/

# spark
RUN \
  cd /usr/local && curl -LO http://www.us.apache.org/dist/spark/spark-2.0.1/spark-2.0.1-bin-hadoop2.7.tgz && \
  tar -xzf spark-2.0.1-bin-hadoop2.7.tgz && \
  ln -s spark-2.0.1-bin-hadoop2.7 spark && \
  rm spark-2.0.1-bin-hadoop2.7.tgz

ENV SPARK_HOME /usr/local/spark
RUN echo 'SPARK_HOME="/usr/local/spark"' >> /etc/environment
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin



#Install Kafka
RUN wget http://apache.belnet.be/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz
RUN tar xvzf kafka_2.11-0.10.0.0.tgz
RUN mv kafka_2.11-0.10.0.0 kafka

ENV PATH $HOME/spark/bin:$HOME/spark/sbin:$HOME/kafka/bin:$PATH

# hive
#RUN \
#  cd /usr/local && curl -LO http://www.us.apache.org/dist/hive/hive-2.0.1/apache-hive-2.0.1-bin.tar.gz && \
#  tar -xzf apache-hive-2.0.1-bin.tar.gz && \
#  ln -s apache-hive-2.0.1-bin hive && \
#  rm apache-hive-2.0.1-bin.tar.gz

#ENV HIVE_HOME /usr/local/hive
#ENV HADOOP_USER_CLASSPATH_FIRST true
#RUN \
#  echo 'HIVE_HOME="/usr/local/hive"' >> /etc/environment && \
#  echo 'HADOOP_USER_CLASSPATH_FIRST="true"' >> /etc/environment
#ENV PATH $PATH:$HIVE_HOME/bin
#COPY config/account.csv /root/
#COPY config/hive-create.sh /root/


#Start Hadoop services
RUN chmod 777 /root/*
#RUN /root/init-nn.sh
#RUN /usr/local/hadoop/sbin/hadoop-daemon.sh start datanode
#RUN /usr/local/hadoop/sbin/yarn-daemon.sh start resourcemanager
#RUN /usr/local/hadoop/sbin/yarn-daemon.sh start nodemanager

COPY kafka/kafka-producer-exec /root/
COPY sparkParser/SparkParser.jar /root/
RUN rm -rf /tmp/hadoop-root/dfs/data/*
COPY config/log4j.properties /root/
RUN mkdir /usr/local/hive
RUN mkdir /usr/local/hive/conf
COPY config/hive-site.xml /usr/local/hive/conf



# RUN kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 3 --topic transaction
#RUN /root/init-nn.sh -y
#RUN ./root/hive-create.sh
#Install Anaconda Python distribution
#RUN wget http://repo.continuum.io/archive/Anaconda2-4.1.1-Linux-x86_64.sh
#RUN bash Anaconda2-4.1.1-Linux-x86_64.sh -b
#ENV PATH $HOME/anaconda2/bin:$PATH
#RUN conda install python=2.7.10 -y

#Install Jupyer notebook + Toree Scala kernel
#RUN conda install jupyter -y 

#Install Kafka Python module
#RUN pip install kafka-python

#USER root

#Startup (start SSH, Cassandra, Zookeeper, Kafka producer)
#ADD startup_script.sh /usr/bin/startup_script.sh
#RUN chmod +x /usr/bin/startup_script.sh

#Environment variables for Spark and Java
#ADD setenv.sh /home/guest/setenv.sh
#RUN chown guest:guest setenv.sh
#RUN echo . ./setenv.sh >> .bashrc

#Init Cassandra 
#ADD init_cassandra.cql /home/guest/init_cassandra.cql
#RUN chown guest:guest init_cassandra.cql

#Add notebooks
#ADD notebooks /home/guest/notebooks
#RUN chown -R guest:guest notebooks

#Install Cassandra
#ADD datastax.repo /etc/yum.repos.d/datastax.repo
#RUN yum install -y datastax-ddc
#RUN echo "/usr/lib/python2.7/site-packages" |tee /home/guest/anaconda2/lib/python2.7/site-packages/cqlshlib.pth

#Install HBase


EXPOSE 22 7077 8020 8030 8031 8032 8033 8040 8042 8088 8888 9200 9300 10000 50010 50020 50060
