WITH main_t as (select year, month, day, sum(quant) as total_q
			 from sales
			 group by year, month, day),
	 t_ag as (select year, month, min(total_q) as slow_q, max(total_q) as busy_q
			  from main_t
			  group by year, month),
	t_ag1 as (select main_t.year, main_t.month, main_t.day as slowest_day, t_ag.slow_q as slowest_total_q
			 from main_t, t_ag
			 where main_t.year = t_ag.year and main_t.month = t_ag.month and main_t.total_q = t_ag.slow_q),
	t_ag2 as (select main_t.year, main_t.month, main_t.day as busiest_day, t_ag.busy_q as busiest_total_q
			 from main_t, t_ag
			 where main_t.year = t_ag.year and main_t.month = t_ag.month and main_t.total_q = t_ag.busy_q)
select distinct t_ag1.year, t_ag1.month, t_ag1.slowest_day, t_ag1.slowest_total_q, t_ag2.busiest_day, t_ag2.busiest_total_q
from t_ag1
FULL JOIN t_ag2
ON t_ag1.year = t_ag2.year and t_ag1.month = t_ag2.month;											    