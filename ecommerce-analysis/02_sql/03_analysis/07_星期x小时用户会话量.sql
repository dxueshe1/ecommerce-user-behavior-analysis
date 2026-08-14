create or replace table 星期x小时用户会话量 as
select
	case extract(dow from event_date) 
		when 0 then '周日'
		when 1 then '周一'
		when 2 then '周二'
		when 3 then '周三'
		when 4 then '周四'
		when 5 then '周五'
		when 6 then '周六'
	end as day_of_week,
	event_hour,
	sum(event_count) as sum_event_count
from (
	select
		date(event_time) as event_date,
		extract(hour from event_time) as event_hour,
		count(user_session) as event_count
	from ecommerce_clean
	where event_type = 'view'
	group by event_date,event_hour
	) as sub
group by day_of_week,event_hour
order by 
	case day_of_week
		when '周一' then 1
		when '周二' then 2
		when '周三' then 3
		when '周四' then 4
		when '周五' then 5
		when '周六' then 6
		when '周日' then 7	
	end,
	event_hour
	