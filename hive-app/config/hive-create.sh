#!/bin/bash

/usr/local/hadoop/bin/hadoop fs -mkdir /table
/usr/local/hadoop/bin/hadoop fs -mkdir /table/account
/usr/local/hadoop/bin/hadoop fs -put account.csv /table/account

#/usr/local/hive/bin/schematool -dbType derby -initSchema &
/usr/local/hive/bin/hive -e "create external table account (id int, acct_num string, acc_credit_limit float, acc_type string) row format delimited fields terminated by '|' stored as textfile location '/table/account'"
/usr/local/hive/bin/hive -e "select * from account"

