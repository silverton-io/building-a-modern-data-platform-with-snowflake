-- ####################################################################################################################
-- We first want to get rid of pre-existing sample databases
-- ####################################################################################################################
drop database if exists demo_db;
drop database if exists snowflake_sample_data;
drop database if exists util_db;


-- ####################################################################################################################
-- Next we need to set up databases.
--      For the sake of example, I'm going to namespace databases by {ENV}_{CLASS OF DATA}.
--      There are many ways to do this, and flavor will largely depend on
-- ####################################################################################################################
-- Create global
create database util;
-- Create dev environment
create database dev_raw;
create database dev_raw_sensitive;
create database dev_analytics;
-- Create prod environment
create database prod_raw;
create database prod_raw_sensitive;
create database prod_analytics;


-- ####################################################################################################################
-- You can do this.... because Snowflake is awesome
-- ####################################################################################################################
drop database prod_raw;
undrop database prod_raw;

create database stage_analytics clone prod_analytics;
create database stage_raw_sensitive clone prod_raw_sensitive;


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
drop database if exists prod_raw;
drop database if exists prod_raw_sensitive;
drop database if exists prod_analytics;
