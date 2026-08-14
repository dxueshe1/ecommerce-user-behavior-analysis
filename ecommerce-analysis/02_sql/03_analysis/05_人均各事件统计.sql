create or replace table 人均各事件数统计 as
with total_user as(
	select count(distinct user_id) as total_user_count
	from ecommerce_clean
)
select 
	distinct event_type,
	count(*) as total_events,
	total_events/(select total_user_count from total_user) as avg_per_all_users,
	total_events/count(distinct user_id) as avg_per_active_users
from ecommerce_clean
group by event_type
