WITH ag_t as (select cust as Customer, min(quant) as min_q, max(quant) as max_q, avg(quant) as avg_q
			  from sales
			  group by cust)
select distinct ag_t.customer as CUSTOMER, ag_t.min_q as MIN_Q, s1.prod as MIN_PROD, s1.date as MIN_DATE, s1.state as ST,
ag_t.MAX_Q as max_q, s2.prod as MAX_PROD, s2.date as MAX_DATE, s2.state as ST,
ag_t.avg_q as AVG_Q
from ag_t
LEFT JOIN sales s1
ON s1.cust = ag_t.customer and s1.quant = ag_t.min_q
LEFT JOIN sales s2
ON s2.cust = ag_t.customer and s2.quant = ag_t.max_q;