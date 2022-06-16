/*--
Name - Chetan Goyal
CWID - 20005334
Course code - CS 561 - B
Submission to - Prof. Samuel Kim
--*/

/*--
Query 1
*/--

With t_avg as (select cust, prod, month, avg(quant) quant
			  from sales
			  group by cust, prod, month),
	t1 as (select sales.cust, sales.prod, sales.month, sales.quant
		  from sales INNER JOIN t_avg
		  ON sales.cust = t_avg.cust and sales.prod = t_avg.prod and sales.month = t_avg.month + 1 and sales.quant > t_avg.quant),
	t2 as (select t1.cust, t1.prod, t1.month, t1.quant
		  from t1 INNER JOIN t_avg
		  ON t1.cust = t_avg.cust and t1.prod = t_avg.prod and t1.month = t_avg.month - 1 and t1.quant < t_avg.quant),
	t3 as (select sales.cust, sales.prod, sales.month, sales.quant
		  from sales INNER JOIN t_avg
		  ON sales.cust = t_avg.cust and sales.prod = t_avg.prod and sales.month = t_avg.month + 1 and sales.quant < t_avg.quant),
	t4 as (select t3.cust, t3.prod, t3.month, t3.quant
		  from t3 INNER JOIN t_avg
		  ON t3.cust = t_avg.cust and t3.prod = t_avg.prod and t3.month = t_avg.month - 1 and t3.quant > t_avg.quant),
	t_union as (select * from t2 UNION select * from t4),
	t_final as (select distinct sales.cust , sales.prod , sales.month, t_union.quant from sales
	LEFT JOIN t_union
	ON sales.cust = t_union.cust and sales.prod = t_union.prod and sales.month = t_union.month)
	select cust customer, prod product, month, count(quant) SALES_COUNT_BETWEEN_AVGS
			   from t_final
			   group by cust, prod, month
			   order by customer, product, month;

/*--
Query 2
*/--

With t_ag as (select cust, prod, month, avg(quant) as during_avg
			 from sales
			 group by cust, prod, month)
select t_cur.cust customer, t_cur.prod product, t_cur.month, round(t_past.during_avg) as before_avg, round(t_cur.during_avg) during_avg, round(t_future.during_avg) as after_avg
from t_ag as t_cur
LEFT JOIN t_ag as t_past
ON t_past.cust = t_cur.cust and t_past.prod = t_cur.prod and t_cur.month - 1 = t_past.month
LEFT JOIN t_ag as t_future
ON t_future.cust = t_cur.cust and t_future.prod = t_cur.prod and t_cur.month + 1 = t_future.month
order by customer, product, month;

/*--
Query 3
*/--


With t_ag as (select cust, prod, state, avg(quant) quant
			 from sales
			 group by cust, prod, state),
	t_othercust as (select s1.cust, s1.prod, s1.state, avg(s2.quant) quant
				   from sales s1
				   LEFT JOIN sales s2
				   ON s1.prod = s2.prod and s1.state = s2.state and s1.cust <> s2.cust
				   group by s1.cust, s1.prod, s1.state),
	t_otherstate as (select s1.cust, s1.prod, s1.state, avg(s2.quant) quant
				   from sales s1
				   LEFT JOIN sales s2
				   ON s1.prod = s2.prod and s1.state <> s2.state and s1.cust = s2.cust
				   group by s1.cust, s1.prod, s1.state),
	t_otherprod as (select s1.cust, s1.prod, s1.state, avg(s2.quant) quant
				   from sales s1
				   LEFT JOIN sales s2
				   ON s1.prod <> s2.prod and s1.state = s2.state and s1.cust = s2.cust
				   group by s1.cust, s1.prod, s1.state)
select t_ag.cust customer, t_ag.prod product, t_ag.state state, round(t_ag.quant) PROD_AVG, round(t_othercust.quant) OTHER_CUST_AVG, round(t_otherprod.quant) OTHER_PROD_AVG, round(t_otherstate.quant) OTHER_STATE_AVG
from t_ag
LEFT JOIN t_othercust
ON t_ag.cust = t_othercust.cust and t_ag.prod = t_othercust.prod and t_ag.state = t_othercust.state
LEFT JOIN t_otherstate
ON t_ag.cust = t_otherstate.cust and t_ag.prod = t_otherstate.prod and t_ag.state = t_otherstate.state
LEFT JOIN t_otherprod
ON t_ag.cust = t_otherprod.cust and t_ag.prod = t_otherprod.prod and t_ag.state = t_otherprod.state
order by customer, product, state;

/*--
Query 4
*/--

With t_main as (select * from sales where state = 'NJ'),
     t1 as (select cust, max(quant) quant
		   from t_main
		   group by cust),
	t1_1 as (select cust, quant from t_main except select * from t1),
	t2 as (select cust, max(quant) quant
		   from t1_1
		   group by cust),
	t2_1 as (select cust, quant from t1_1 except select * from t2),
	t3 as (select cust, max(quant) quant
		  from t2_1
		  group by cust),
	t_union as (select * from t1 union select * from t2 union select * from t3)
select t_union.cust customer, t_union.quant quantity, t_main.prod product, t_main.date
from t_union
LEFT JOIN t_main
ON t_union.cust = t_main.cust and t_union.quant = t_main.quant
order by customer, quantity;

/*--
Query 5
*/--

With t_ag as (select cust, prod, month, sum(quant) quant
			 from sales
			 group by cust, prod, month),
	t_upto as (select t1.cust, t1.prod, t1.month, sum(t2.quant) quant
			  from t_ag t1
			  LEFT JOIN t_ag t2
			  ON t1.cust = t2.cust and t1.prod = t2.prod and t1.month >= t2.month
			  group by t1.cust, t1.prod, t1.month),
	t_total as (select cust, prod, sum(quant)/3 quant
			   from sales
			   group by cust, prod),
	t_by as (select t_upto.cust, t_upto.prod, min(t_upto.quant) quant
			from t_total
			LEFT JOIN t_upto
			ON t_upto.cust = t_total.cust and t_upto.prod = t_total.prod and t_upto.quant >= t_total.quant
			group by t_upto.cust, t_upto.prod)
select t_upto.cust customer, t_upto.prod product, t_upto.month as "1/3 PURCHASED BY MONTH"
from t_by
LEFT JOIN t_upto
ON t_upto.cust = t_by.cust and t_upto.prod = t_by.prod and t_upto.quant = t_by.quant
order by customer, product, month;