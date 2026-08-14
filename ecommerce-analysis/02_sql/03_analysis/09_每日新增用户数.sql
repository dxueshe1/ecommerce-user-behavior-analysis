create or replace table 每日新增用户数 as
with 
    user_first_time as(
        SELECT 
            date(min(event_time)) AS first_time,
            user_id,
        FROM ecommerce_clean
        group by user_id
    )
select 
	first_time,
	count(*) as new_user
from user_first_time
group by first_time
order by first_time
