create or replace table 每日用户趋势 as
with 
user_first as (
    select 
        user_id,
        date(min(event_time)) as first_date,
        count(distinct date(event_time)) as active_day
    from ecommerce_clean
    group by user_id
),
global_end_date as (
    select max(event_time) as max_dt 
    from ecommerce_clean
),
-- 给每个用户打标签，逻辑与用户分类表完全一致
user_label as (
    select 
        u.user_id,
        u.first_date,
        u.active_day,
        case 
            when u.first_date <= date(g.max_dt - interval 30 day)
                 and u.active_day > 1
            then '老用户'
            when u.first_date > date(g.max_dt - interval 30 day)
            then '新用户'
            else '一次性流量'
        end as user_type
    from user_first u
    cross join global_end_date g
)
select
    date(e.event_time) as total_date,
    -- DAU
    count(distinct e.user_id) as DAU,
    -- 新用户：当天首次活跃
    count(distinct case when date(e.event_time) = l.first_date then e.user_id end) as new_user,
    -- 老用户：当天活跃且标签为老用户
    count(distinct case when l.user_type = '老用户' then e.user_id end) as old_user,
    -- 一次性流量：当天活跃且标签为一次性流量
    count(distinct case when l.user_type = '一次性流量' then e.user_id end) as one_time_user
from ecommerce_clean e
join user_label l on e.user_id = l.user_id
group by date(e.event_time)
order by total_date;