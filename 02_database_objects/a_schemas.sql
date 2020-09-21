-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


-- ####################################################################################################################
-- Set up raw source schemas
-- ####################################################################################################################
create schema raw.snowplow comment = 'Raw site traffic data';
create schema raw.titanic comment = 'Raw titanic data' data_retention_time_in_days = 1;


-- ####################################################################################################################
-- Set up analytics schemas
-- ####################################################################################################################
create schema analytics.titanic comment = 'Assets for titanic passenger research';
create schema analytics.web comment = 'Assets for website traffic analysis';

-- There are many directions to go here, depending on business needs.
-- create schema analytics.gaap;
-- create schema analytics.investors;
-- create schema analytics.business_health;
-- create schema analytics.sem;
-- create schema analytics.product_usage;
-- create schema analytics.product_adoption;
-- create schema analytics.employee_retention;
-- create schema analytics.code_velocity;


-- ####################################################################################################################
-- To view everything we've just created
-- ####################################################################################################################
show schemas in database raw;
show schemas in database analytics;


-- ####################################################################################################################
-- To clean up everything we've just created
-- ####################################################################################################################
drop schema raw.snowplow;
drop schema raw.titanic;
drop schema analytics.titanic;
drop schema analytics.web;
