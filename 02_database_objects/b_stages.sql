-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


-- ####################################################################################################################
-- Create stages for loading data
-- ####################################################################################################################
create stage raw.titanic.load_stg file_format = (type = csv) comment = 'An internal stage for loading titanic data';
create stage raw.snowplow.load_stg file_format = (type = json) comment = 'An internal stage for loading snowplow event data';


-- ####################################################################################################################
-- To view everything we've just created
-- ####################################################################################################################
show stages in schema raw.titanic;
describe stage raw.titanic.load_stg;

show stages in schema raw.snowplow;
describe stage raw.snowplow.load_stg;


-- ####################################################################################################################
-- To clean up everything we've just created
-- ####################################################################################################################
drop stage if exists raw.titanic.load_stg;
drop stage if exists raw.snowplow.load_stg;
