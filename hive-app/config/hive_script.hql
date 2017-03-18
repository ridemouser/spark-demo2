Set scenario_id='Sc01';
set scenario_name='Cross Border Cash Advance and Withdrawls';
set run_date='2017-02-28';
set last_run_date='2017-01-31';
set lookback_range=90;
set count_tran_since_last_run=1;
set ccash_advance_cross_border_flag='Y';
set ccash_advance_tran_type_code='60';
set ccash_withdrawal_tran_type_code='61';
set ccash_withdrawal_merchant_code_list='7001','7002','7003','7004','7005','7006','7007','7008','7009','70010','70011','70012','70013','70014','70015','70016','70017','70018','70019','70020';
set ctry_risk_rating_high='H';
set ctry_risk_rating_medium='M';
set ctry_risk_rating_low='L';

Create table xborder_cust_segment as
select 
${hiveconf:scenario_id} as scenario_id,
${hiveconf:scenario_name} as scenario_name,
${hiveconf:run_date} as run_date,
${hiveconf:last_run_date} as last_run_date,
cust_id,
max(t.cust_credit_limit) as cust_credit_limit,
sum(t.tran_amt) as sum_tran_amt,
count(t.tran_amt) as ct_tran,
max( case
	when t.ctry_risk_rating=${hiveconf:ctry_risk_rating_high} then 3
	when t.ctry_risk_rating=${hiveconf:ctry_risk_rating_medium} then 2
	when t.ctry_risk_rating=${hiveconf:ctry_risk_rating_low} then 1
	else 0 end
) as max_ctry_risk_rating,
max(t.acc_type) as acc_type,
max(t.tran_type_code) as tran_type_code,
max(t.merchant_code) as merchant_code,
max(t.sys_update_dt) as sys_update_dt,
sum(case when substr(t.sys_update_dt,0,10) > ${hiveconf:last_run_date} then 1 else 0 end) as ct_tran_since_last_run,
max(
	case
	when t.cust_credit_limit <=1000 then CONCAT(acc_type,'-','01000')
	when t.cust_credit_limit <=2000 then CONCAT(acc_type,'-','02000')
	when t.cust_credit_limit <=4000 then CONCAT(acc_type,'-','04000')
	when t.cust_credit_limit <=6000 then CONCAT(acc_type,'-','06000')
	when t.cust_credit_limit <=10000 then CONCAT(acc_type,'-','010000')
	else CONCAT(acc_type,'-','010001')
	end
) as segment_id
from transactions_aml t
where 
substr(t.sys_update_dt,0,10) < ${hiveconf:run_date}
and substr(t.sys_update_dt,0,10) > date_add(substr(t.sys_update_dt,0,10),-${hiveconf:lookback_range})
and( t.cash_advance_cross_border_flag=${hiveconf:ccash_advance_cross_border_flag}
	and t.tran_type_code=${hiveconf:ccash_advance_tran_type_code}
	)
	OR
	( t.tran_type_code=${hiveconf:ccash_withdrawal_tran_type_code}
	AND t.merchant_code IN (${hiveconf:ccash_withdrawal_merchant_code_list})
	)
group by t.cust_id

