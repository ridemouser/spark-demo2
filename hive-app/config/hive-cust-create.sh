#!/bin/bash

/usr/local/hadoop/bin/hadoop fs -mkdir /table
/usr/local/hadoop/bin/hadoop fs -mkdir /table/customer
/usr/local/hadoop/bin/hadoop fs -put customer.csv /table/customer

#/usr/local/hive/bin/schematool -dbType derby -initSchema &
/usr/local/hive/bin/hive -e "create external table customer (id int, cust_id string, cust_credit_limit float, acc_type string, sys_update_dt string) row format delimited fields terminated by '|' stored as textfile location '/table/customer'"
/usr/local/hive/bin/hive -e "select * from customer"

