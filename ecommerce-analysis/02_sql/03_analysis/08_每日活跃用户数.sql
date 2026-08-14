create or replace table 每日活跃用户数 as
select 
	date(event_time),
	count(distinct user_id)
from ecommerce_clean
group by date(event_time)
order by date(event_time)
	