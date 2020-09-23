-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


-- ####################################################################################################################
-- The first step is cleaning up the pre-existing sample warehouse.
-- ####################################################################################################################
drop warehouse if exists compute_wh;


-- ####################################################################################################################
-- The second step is creating warehouses for various needs or demands.
--      By separating these via function, compute resources will remain separate.
--      Loading data will never interfere with transforming data, which will never interfere with consuming data.
--      I'm setting up three primaries, but overall analytics architecture will dictate what gets set up long term.
-- ####################################################################################################################
create warehouse loader warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for load operations';
create warehouse transformer warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for transform operations';
create warehouse reader warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for read operations';


-- ####################################################################################################################
-- To view what we've just created
-- ####################################################################################################################
show warehouses;


-- ####################################################################################################################
-- To clean up what we've just created (if you need to reset environment)
-- ####################################################################################################################
drop warehouse if exists loader;
drop warehouse if exists transformer;
drop warehouse if exists reader;
