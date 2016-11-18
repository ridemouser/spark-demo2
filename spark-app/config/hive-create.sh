#!/bin/bash

hadoop fs -mkdir /table
hadoop fs -mkdir /table/account
hadoop fs -put account.csv /table/account

/usr/local/hive/bin/schematool -dbType derby -initSchema &
/usr/local/hive/bin/hive -e "create external table account (id int, acct_num string, acc_credit_limit float, acc_type string) row format delimited fields terminated by '|' stored as textfile location '/table/account'"
/usr/local/hive/bin/hive -e "select * from account"

