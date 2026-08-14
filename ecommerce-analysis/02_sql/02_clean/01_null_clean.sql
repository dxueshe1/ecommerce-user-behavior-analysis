create or replace table ecommerce_clean as
select *
from ecommerce_raw
WHERE 
	event_time is not null
	and event_type is not null
	and product_id is not null
	and category_id is not null
	and price is not null
	and user_id is not null