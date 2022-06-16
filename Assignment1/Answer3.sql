WITH t1 as (select cust, month, prod, sum(quant) as quant_sum
		  from sales
		  group by cust, month, prod),
	t2 as (select cust, month, min(quant_sum) as min_quant_sum, max(quant_sum) as max_quant_sum
		  from t1
		  group by cust, month)
select distinct t2.cust, t2.month, ta.prod as most_fav_prod, tb.prod as least_fav_prod
from t2
LEFT JOIN t1 as ta
ON t2.max_quant_sum = ta.quant_sum and ta.cust = t2.cust and ta.month = t2.month
LEFT JOIN t1 as tb
ON t2.min_quant_sum = tb.quant_sum and tb.cust = t2.cust and tb.month = t2.month
order by cust, month;
/*
Hello
*/