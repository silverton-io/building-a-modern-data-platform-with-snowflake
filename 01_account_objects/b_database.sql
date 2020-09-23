-- ####################################################################################################################
-- We first want to get rid of pre-existing sample databases
-- ####################################################################################################################
use role accountadmin;
drop database if exists demo_db;
drop database if exists snowflake_sample_data;
drop database if exists util_db;


-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


-- ####################################################################################################################
-- Next we need to set up databases.
--      For the sake of example, I'm going to namespace databases by {ENV}_{CLASS OF DATA}.
--      There are many ways to structure this, and it largely depends on company norms/policies/etc.
-- ####################################################################################################################
-- Global
create database util comment = 'Global utilities';
-- Dev environment
create database dev_raw comment = 'Raw development-environment data';
create database dev_raw_sensitive comment = 'Raw development-environment data that is particularly sensitive. PII, HIPAA, etc';
create database dev_analytics comment = 'Derived data within the development environment';
-- Prod environment
create database raw comment = 'Raw production data';
create database raw_sensitive comment = 'Raw production data that is particularly sensitive. PII, HIPAA, etc';
create database analytics comment = 'Derived/transformed/aggregated data for the purpose of analytics';


-- ####################################################################################################################
-- You can do this.... because Snowflake is awesome
-- ####################################################################################################################
drop database raw;
undrop database raw;

create database stage_raw clone raw comment = 'Production-volume raw data within the staging environment';
create database stage_analytics clone analytics comment = 'Production-volume derived data within the staging environment';


-- ####################################################################################################################
-- To view what we've just created
-- ####################################################################################################################
show databases;


-- ####################################################################################################################
-- To clean up what we've just created
-- ####################################################################################################################
drop database if exists util;
drop database if exists dev_raw;
drop database if exists dev_raw_sensitive;
drop database if exists dev_analytics;
drop database if exists stage_analytics;
drop database if exists stage_raw_sensitive;
drop database if exists raw;
drop database if exists raw_sensitive;
drop database if exists analytics;
