-- ####################################################################################################################
-- Use the USERADMIN role
-- ####################################################################################################################
use role useradmin;


-- ####################################################################################################################
-- Create a role for loading data into RAW.
-- This role will have the ability to:
--      * create schemas in the raw database
--      * create tables in the raw database
--      * create stages in the raw database
--      * load data into stages/tables 
-- ####################################################################################################################
create role load comment = 'Load role can manage and load data into the raw database.';


-- ####################################################################################################################
-- Create a role for transforming data from RAW to ANALYTICS
-- This role will have the ability to:
--      * read data from tables in RAW database
--      * create schemas in ANALYTICS database
--      * create tables and views (and materialized views, if enterprise tier) in ANALYTICS database
--      * create functions and procs in ANALYTICS database
-- ####################################################################################################################
create role transform comment = 'Transform role can query data from the raw database and manage the analytics database.';


-- ####################################################################################################################
-- Create a role for reading data from ANALYTICS
-- This role will have the ability to:
--      * read data from ANALYTICS database
-- ####################################################################################################################
create role read comment = 'Read role can query tables and views within the analytics database.';


-- ####################################################################################################################
-- To clean up what we've just created
-- ####################################################################################################################
drop role if exists load;
drop role if exists transform;
drop role if exists read;
