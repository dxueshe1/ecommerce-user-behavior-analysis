create or replace table "每日用户趋势" as
with 
user_first as (
    select 
        user_id,
        min(event_time) as first_time,
        count(distinct event_time::date) as active_day
    from ecommerce_clean
    group by user_id
),
global_end_date as (
    select max(event_time) as max_dt 
    from ecommerce_clean
),
user_label as (
    select 
        u.user_id,
        u.first_time,
        case 
            when u.first_time <= g.max_dt - interval 30 day
                 and u.active_day > 1
            then '老用户'
            when u.first_time > g.max_dt - interval 30 day
            then '新用户'
            else '一次性流量'
        end as user_type
    from user_first u
    cross join global_end_date g
)
select
    e.event_time::date as total_date,
    count(distinct e.user_id) as DAU,
    count(distinct case when e.event_time::date = l.first_time::date then e.user_id end) as new_user,
    count(distinct case when l.user_type = '老用户' then e.user_id end) as old_user,
    count(distinct case when l.user_type = '一次性流量' then e.user_id end) as one_time_user
from ecommerce_clean e
join user_label l on e.user_id = l.user_id
group by e.event_time::date
order by total_date;