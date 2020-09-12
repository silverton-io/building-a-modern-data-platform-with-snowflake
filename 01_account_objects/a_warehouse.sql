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
create warehouse reader warehouse_size = xsmall auto_suspend = 59 auto_resume = true initially_suspended = true comment = 'A warehouse for read operation';

alter warehouse reader set comment = 'A warehouse for read operations';


-- ####################################################################################################################
-- The third step (if desired) is creating resource monitors for specified warehouses
-- ####################################################################################################################
create resource monitor loader_mon with credit_quota = 10 frequency = daily start_timestamp = immediately triggers on 50 percent do notify on 110 percent do suspend;
alter warehouse loader set resource_monitor = loader_mon;


-- ####################################################################################################################
-- To view what we've just created
-- ####################################################################################################################
show warehouses;
show resource monitors;

-- ####################################################################################################################
-- To clean up what we've just created (if you need to reset environment)
-- ####################################################################################################################
drop warehouse if exists loader;
drop warehouse if exists transformer;
drop warehouse if exists reader;
drop resource monitor if exists loader_mon;
