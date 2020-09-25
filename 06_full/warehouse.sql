use role sysadmin;


-- Warehouses
drop warehouse if exists compute_wh;
create warehouse loader warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for load operations';
create warehouse transformer warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for transform operations';
create warehouse reader warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for read operations';


-- Databases
use role accountadmin;
drop database if exists demo_db;
drop database if exists snowflake_sample_data;
drop database if exists util_db;

use role sysadmin;
create database util comment = 'Global utilities';

create database dev_raw comment = 'Raw development-environment data';
create database dev_raw_sensitive comment = 'Raw development-environment data that is particularly sensitive. PII, HIPAA, etc';
create database dev_analytics comment = 'Derived data within the development environment';

create database raw comment = 'Raw production data';
create database raw_sensitive comment = 'Raw production data that is particularly sensitive. PII, HIPAA, etc';
create database analytics comment = 'Derived/transformed/aggregated data for the purpose of analytics';


-- Schemas
create schema raw.snowplow comment = 'Raw site traffic data';
create schema raw.titanic comment = 'Raw titanic data';

create schema analytics.titanic comment = 'Assets for titanic passenger research';
create schema analytics.web comment = 'Assets for website traffic analysis';


-- Stages
create stage raw.titanic.load_stg file_format = (type = csv) comment = 'An internal stage for loading titanic data';
create stage raw.snowplow.load_stg file_format = (type = json) comment = 'An internal stage for loading snowplow event data';


-- Raw tables
create table raw.titanic.passengers (
    passenger_id    integer primary key,
    survived        boolean,
    pclass          integer,
    name            text,
    sex             varchar(6),
    age             integer,
    sib_sp          integer,
    parch           integer,
    ticket          varchar(16),
    fare            float,
    cabin           varchar(16),
    embarked        text
);


create table raw.snowplow.events (
    dvce_created_tstamp     timestamp,
    collector_tstamp        timestamp,
    etl_tstamp              timestamp,
    domain_userid           varchar(36),
    domain_sessionid        varchar(36),
    domain_sessionidx       integer,
    app_id                  varchar(4),
    event_id                varchar(36),
    event                   varchar(36),
    page_title              text,
    page_url                text,
    refr_urlhost            text,
    br_lang                 varchar(5),
    br_type                 varchar(32),
    br_family               varchar(128),
    br_version              varchar(16),
    geo_timezone            varchar(32),
    geo_city                varchar(64),
    geo_country             varchar(64),
    geo_region_name         varchar(128),
    geo_zipcode             varchar(16),
    os_timezone             varchar(32)
);


-- Analytics views/tables
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


-- Load structured data
use warehouse loader;
put file:///ABSOLUTE_PATH_TO/building-a-modern-data-platform-with-snowflake/data/titanic.csv.gz @raw.titanic.load_stg/ auto_compress = true source_compression = none;
copy into raw.titanic.passengers from @raw.titanic.load_stg/titanic.csv.gz file_format = (type = csv field_delimiter = ',' skip_header = 1 field_optionally_enclosed_by='"');


-- Load semi-structured data
use warehouse loader;
put file:///ABSOLUTE_PATH_TO/building-a-modern-data-platform-with-snowflake/data/events.json.gz @raw.snowplow.load_stg/ auto_compress = true source_compression = gzip;
copy into raw.snowplow.events from @raw.snowplow.load_stg/events.json.gz file_format = (type = json) match_by_column_name = case_insensitive purge = false;


-- Create roles
use role useradmin;
create role load comment = 'Load role can manage and load data into the raw database.';
create role transform comment = 'Transform role can query data from the raw database and manage the analytics database.';
create role read comment = 'Read role can query tables and views within the analytics database.';


-- Create users and assign them to roles
create user loader
    login_name = 'loader'
    display_name = 'loader'
    password = 'changeme!'
    must_change_password = false
    comment = 'A programmatic user for loading data'
    default_warehouse = loader
    default_role = load;

create user transformer
    login_name = 'transformer'
    display_name = 'transformer'
    password = 'ChangeME2!'
    must_change_password = false
    comment = 'A programmatic user for transforming data'
    default_warehouse = transformer
    default_role = transform;

create user reader
    login_name = 'reader'
    display_name = 'reader'
    password = 'chgmplz#4'
    must_change_password = false
    comment = 'A programmatic user for reading analytics data'
    default_warehouse = reader
    default_role = read;


-- Grant appropriate privileges to said roles
grant usage on warehouse loader to role load;
grant usage on database raw to role load;
grant create schema on database raw to role load;
grant ownership on all schemas in database raw to role load;
grant ownership on all stages in schema raw.snowplow to role load;
grant ownership on all tables in schema raw.snowplow to role load;
grant ownership on all stages in schema raw.titanic to role load;
grant ownership on all tables in schema raw.titanic to role load;

grant usage on warehouse transformer to role transform;
grant usage on database raw to role transform;
grant usage on all schemas in database raw to role transform;
grant select on all tables in database raw to role transform;
grant ownership on all schemas in database analytics to role transform;
grant ownership on all tables in schema analytics.web to role transform;
grant ownership on all views in schema analytics.web to role transform;
grant ownership on all tables in schema analytics.titanic to role transform;
grant ownership on all views in schema analytics.titanic to role transform;

grant usage on warehouse reader to role read;
grant usage on database analytics to role read;
grant usage on all schemas in database analytics to role read;
grant select on all views in schema analytics.web to role read;
grant select on all tables in schema analytics.web to role read;
grant select on all views in schema analytics.titanic to role read;
grant select on all tables in schema analytics.titanic to role read;


-- Grant future privileges
grant usage on future schemas in database raw to role transform;
grant select on future tables in database raw to role transform;
grant select on future views in database raw to role trasnform;

grant usage on future schemas in database analytics to role read;
grant select on future tables in database analytics to role read;
grant select on future views in database analytics to role read;

