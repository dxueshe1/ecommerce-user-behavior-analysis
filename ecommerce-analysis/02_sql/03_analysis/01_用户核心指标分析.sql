create or replace table 用户核心指标 as
select 
	count(distinct user_id) as user_count,
	count(distinct user_session) as session_count,
	count(distinct user_session)/count(distinct user_id) as session_ave,
	count(event_type)/count(distinct user_id) as event_ave
from ecommerce_clean



