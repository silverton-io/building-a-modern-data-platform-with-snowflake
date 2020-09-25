-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


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


-- ####################################################################################################################
-- To clean up what we've just created
-- ####################################################################################################################
drop table raw.titanic.passengers;
drop table raw.snowplow.events;
