create or replace table 每日用户数量趋势 as
with 
    user_first_time as(
        SELECT 
            date(min(event_time)) AS first_time,
            user_id,
        FROM ecommerce_clean
        group by user_id
    )
select 
	date(e.event_time) as event_day,
	count(distinct e.user_id) as DAU,
	count(distinct case when date(e.event_time) = u.first_time then e.user_id end) as new_user,
	count(distinct case when date(e.event_time) != u.first_time then e.user_id end) as old_user
from ecommerce_clean e join user_first_time u on e.user_id = u.user_id
group by date(e.event_time)