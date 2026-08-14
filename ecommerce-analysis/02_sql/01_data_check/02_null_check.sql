select 
	user_session,
	count(distinct user_id) as user_count
from  ecommerce_raw
group by user_session
having user_count > 1
order by user_count desc