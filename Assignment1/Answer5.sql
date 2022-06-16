WITH table_q1_1 as (select prod, max(quant) as Q1_MAX
							 from sales
							 where month = 1 or month = 2 or month = 3
							 group by prod),
				 table_q2_1 as (select prod, max(quant) as Q2_MAX
							 from sales
							 where month = 4 or month = 5 or month = 6
							 group by prod),
				 table_q3_1 as (select prod, max(quant) as Q3_MAX
								 from sales
								 where month = 7 or month = 8 or month = 9
								 group by prod),
				 table_q4_1 as (select prod, max(quant) as Q4_MAX
								 from sales
								 where month = 10 or month = 11 or month = 12
								 group by prod),
				 table_q1_2 as (select table_q1_1.prod, table_q1_1.q1_max, sales.date
							   from table_q1_1, sales
							   where table_q1_1.prod = sales.prod and table_q1_1.q1_max = sales.quant and (sales.month = 1 or sales.month = 2 or sales.month = 3)),
			   	table_q2_2 as (select table_q2_1.prod, table_q2_1.q2_max, sales.date
							 from table_q2_1, sales
							 where table_q2_1.prod = sales.prod and table_q2_1.q2_max = sales.quant and (sales.month = 4 or sales.month = 5 or sales.month = 6)),
				 table_q3_2 as (select table_q3_1.prod, table_q3_1.q3_max, sales.date
							 from table_q3_1, sales
							 where table_q3_1.prod = sales.prod and table_q3_1.q3_max = sales.quant and (sales.month = 7 or sales.month = 8 or sales.month = 9)),
				 table_q4_2 as (select table_q4_1.prod, table_q4_1.q4_max, sales.date
							 from table_q4_1, sales
							 where table_q4_1.prod = sales.prod and table_q4_1.q4_max = sales.quant and (sales.month = 10 or sales.month = 11 or sales.month = 12))	
select distinct table_q1_2.prod, table_q1_2.q1_max, table_q1_2.date, table_q2_2.q2_max, table_q2_2.date, table_q3_2.q3_max, table_q3_2.date, table_q4_2.q4_max, table_q4_2.date
from table_q1_2, table_q2_2, table_q3_2, table_q4_2
where table_q1_2.prod = table_q2_2.prod and table_q1_2.prod = table_q3_2.prod and table_q1_2.prod = table_q4_2.prod;
	