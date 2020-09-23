-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


-- ####################################################################################################################
-- Create views and tables for titanic data
-- ####################################################################################################################
create or replace view
    analytics.titanic.passengers_survived
comment = 'A view of the surviving titanic passengers'
as select
    *
from
    raw.titanic.passengers
where
    survived = true;


create or replace view
    analytics.titanic.passengers_not_survived
comment = 'A view of the titanic passengers who did not survive'
as select
    *
from
    raw.titanic.passengers
where
    survived = false;


create or replace table analytics.titanic.age_buckets (
    age_range   varchar(8),
    sex         varchar(6),
    survived    boolean,
    pclass      integer,
    avg_fare    float
)
comment = 'Age buckets of titanic passengers, avg fares, and survival status'
as
    select
        case
            when age < 20 then '<20'
            when age between 20 and 29 then '20s'
            when age between 30 and 39 then '30s'
            when age between 40 and 49 then '40s'
            when age between 50 and 59 then '50s'
            when age between 60 and 69 then '60s'
            when age >= 70 then '70+'
            when age is null then 'Unknown'
        end as age_range,
        sex,
        survived,
        pclass,
        avg(fare) as avg_fare
    from
        raw.titanic.passengers
    group by
        1,2,3,4;

-- select * from analytics.titanic.demographics order by age_range, sex, pclass, survived;


-- ####################################################################################################################
-- Create views and tables for web data
-- ####################################################################################################################
create or replace view -- create or replace is an easy (but potentially dangerous!) way to roll new view definitions into place.
    analytics.web.daily_user_session_agg
as select
    date_trunc('day', collector_tstamp)::date as day,
    count(distinct domain_userid) as users,
    count(distinct domain_sessionid) as sessions
from
    raw.snowplow.events
 group by
    1;


create or replace view
    analytics.web.page_stats
as select
    page_url,
    count(distinct domain_userid) as users,
    count(distinct domain_sessionid) as sessions
from
    raw.snowplow.events
group by
    1;


-- ####################################################################################################################
-- To clean up what we've just created
-- ####################################################################################################################
drop view analytics.titanic.passengers_survived;
drop view analytics.titanic.passengers_not_survived;
drop table analytics.titanic.age_buckets;

drop view analytics.web.daily_user_session_agg;
drop view analytics.web.page_stats;
