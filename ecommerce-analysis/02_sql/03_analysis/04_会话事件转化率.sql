create or replace table 会话事件转化率 as
with total_session_count as (
	select count(distinct user_session) as total_session
	from ecommerce_clean
)
select
	event_type,
	count(distinct user_session) as event_session_count,
	event_session_count/(select total_session from total_session_count) as session_event_conversion
from ecommerce_clean
group by event_type
