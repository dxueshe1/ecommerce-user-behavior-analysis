create or replace table 用户分类 as
with 
	user_first_time as(
		SELECT 
			min(event_time) AS first_time,
			user_id,
			count(distinct date(event_time)) as active_day
		FROM ecommerce_clean
		group by user_id
	),
	global_end_date AS (
    	select max(event_time) as max_dt 
    	from  ecommerce_clean
	)   
	
select 
	CASE 
		when u.first_time <= (g.max_dt - interval 30 day)
			and u.active_day > 1
		then '老用户' 
		
		when u.first_time > (g.max_dt - interval 30 day)
		then '新用户'
		
		else '一次性流量'
	END as user_type,
	count(distinct u.user_id) as user_scale
	
from user_first_time u,global_end_date g
group by user_type
