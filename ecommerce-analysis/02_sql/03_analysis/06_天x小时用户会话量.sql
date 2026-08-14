create or replace table 天x小时用户会话量 as
select
	date(event_time) as event_date,
	extract(hour from event_time) as event_hour,
	count(user_session) as event_count
from ecommerce_clean
where event_type = 'view'
group by event_date,event_hour
order by event_date,event_hour
	