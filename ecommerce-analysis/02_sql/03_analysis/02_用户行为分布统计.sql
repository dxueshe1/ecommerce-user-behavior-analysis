create or replace table 用户行为类型分布 as
select 
	distinct event_type,
	count(*) as user_event_count
from ecommerce_clean
group by event_type
order by user_event_count

