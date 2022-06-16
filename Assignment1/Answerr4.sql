WITH table_q1 as (select cust, prod, avg(quant) as Q1_AVG
			   from sales
			   where month = 1 or month = 2 or month = 3
			   group by cust, prod),
			   table_q2 as (select cust, prod, avg(quant) as Q2_AVG
			   from sales
			   where month = 4 or month = 5 or month = 6
			   group by cust, prod),
			   table_q3 as (select cust, prod, avg(quant) as Q3_AVG
			   from sales
			   where month = 7 or month = 8 or month = 9
			   group by cust, prod),
			   table_q4 as (select cust, prod, avg(quant) as Q4_AVG
			   from sales
			   where month = 10 or month = 11 or month = 12
			   group by cust, prod),
			   table_ag as (select cust, prod, avg(quant) as AVG, sum(quant) as TOTAL, count(quant) as COUNT
						 from sales
						 group by cust, prod)
select distinct table_q1.cust as CUSTOMER, table_q1.prod as PRODUCT, table_q1.Q1_AVG, table_q2.Q2_AVG, table_q3.Q3_AVG, table_q4.Q4_AVG, table_ag.avg, table_ag.total, table_ag.count
from table_q1
FULL JOIN table_q2
ON table_q1.cust = table_q2.cust and table_q1.prod = table_q2.prod
FULL JOIN table_q3
ON table_q1.cust = table_q3.cust and table_q1.prod = table_q3.prod
FULL JOIN table_q4
ON table_q1.cust = table_q4.cust and table_q1.prod = table_q4.prod
FULL JOIN table_ag
ON table_q1.cust = table_ag.cust and table_q1.prod = table_ag.prod;

/*
WITH table_q1 as (select cust, prod, avg(quant) as Q1_AVG
			   from sales
			   where month = 1 or month = 2 or month = 3
			   group by cust, prod),
			   table_q2 as (select cust, prod, avg(quant) as Q2_AVG
			   from sales
			   where month = 4 or month = 5 or month = 6
			   group by cust, prod),
			   table_q3 as (select cust, prod, avg(quant) as Q3_AVG
			   from sales
			   where month = 7 or month = 8 or month = 9
			   group by cust, prod),
			   table_q4 as (select cust, prod, avg(quant) as Q4_AVG
			   from sales
			   where month = 10 or month = 11 or month = 12
			   group by cust, prod),
			   table_ag as (select cust, prod, avg(quant) as AVG, sum(quant) as TOTAL, count(quant) as COUNT
						 from sales
						 group by cust, prod)
select distinct table_q1.cust as CUSTOMER, table_q1.prod as PRODUCT, table_q1.Q1_AVG, table_q2.Q2_AVG, table_q3.Q3_AVG, table_q4.Q4_AVG, table_ag.avg, table_ag.total, table_ag.count
from table_q1, table_q2, table_q3, table_q4, table_ag
where table_q1.cust = table_q2.cust and table_q1.prod = table_q2.prod
and table_q1.cust = table_q3.cust and table_q1.prod = table_q3.prod
and table_q1.cust = table_q4.cust and table_q1.prod = table_q4.prod
and table_q1.cust = table_ag.cust and table_q1.prod = table_ag.prod;
*/