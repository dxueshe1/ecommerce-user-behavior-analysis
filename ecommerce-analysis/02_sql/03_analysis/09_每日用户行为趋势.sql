create or replace table 每日用户行为趋势 as
select
	date(event_time) as event_day,
	count(case when event_type = 'view' then user_id end) as view_count,
	count(case when event_type = 'cart' then user_id end) as cart_count,
	count(case when event_type = 'purchase' then user_id end) as purchase_count
from ecommerce_clean
group by date(event_time)
order by date(event_time)
