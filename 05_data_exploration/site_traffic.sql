-- Check out aggregate site traffic

select
    *
from
    analytics.web.page_stats;


select
    *
from
    analytics.web.daily_user_sessions;


select
    date_trunc('hour', collector_tstamp) as hour,
    count(distinct event_id) as events
from
    analytics.web.events
group by
    1
order by
    1 asc;
