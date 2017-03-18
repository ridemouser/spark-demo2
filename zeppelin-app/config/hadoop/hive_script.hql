set ccash_advance_cross_border_flag='Y';
set ccash_advance_tran_type_code='60';
set ccash_withdrawal_tran_type_code='61';
set ccash_withdrawal_merchant_code_list='7001','7002','7003','7004','7005','7006','7007','7008','7009','70010','70011','70012','70013','70014','70015','70016','70017','70018','70019','70020';
set ctry_risk_rating_high='H';
set ctry_risk_rating_medium='M';
set ctry_risk_rating_low='L';
Create table Temp_output as
select cust_id,
max(t.cust_credit_limit) as cust_credit_limit
sum(t.tran_amt) as sum_tran_amt,
count(t.tran_amt) as ct_tran,
max( case
	when t.ctry_risk_rating=${ctry_risk_rating_high} then 3
	when t.ctry_risk_rating=${ctry_risk_rating_medium} then 2
	when t.ctry_risk_rating=${ctry_risk_rating_low} then 1
	else 0
) as max_ctry_risk_rating,
max(t.sys_update_dt) as sys_update_dt
from transactions_aml t
where ( t.cash_advance_cross_border_flag=${ccash_advance_cross_border_flag}
	and t.cash_advance_tran_type_code=${ccash_advance_tran_type_code}
	)
	OR
	( t.cash_advance_tran_type_code=${ccash_withdrawal_tran_type_code}
	AND t.cash_withdrawal_merchant_code IN ${ccash_withdrawal_merchant_code_list}
	)
group by t.cust_id)tran
