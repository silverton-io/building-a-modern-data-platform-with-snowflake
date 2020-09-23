-- ####################################################################################################################
-- Use the USERADMIN role
-- ####################################################################################################################
use role useradmin;


-- ####################################################################################################################
-- Grant appropriate privileges to load role
-- ####################################################################################################################
-- Grant usage of only the loader warehouse
grant usage on warehouse loader to role load;
-- Grant appropriate access to raw database
grant usage on database raw to role load;
grant create schema on database raw to role load;
-- Grant ownership of existing objects in raw database
grant ownership on all schemas in database raw to role load;
grant ownership on all stages in schema raw.snowplow to role load;
grant ownership on all tables in schema raw.snowplow to role load;
grant ownership on all stages in schema raw.titanic to role load;
grant ownership on all tables in schema raw.titanic to role load;


-- ####################################################################################################################
-- Grant appropriate privileges to transform role
-- ####################################################################################################################
-- Grant usage of only the transformer warehouse
grant usage on warehouse transformer to role transform;
-- Grant appropriate access to raw database
grant usage on database raw to role transform;
grant usage on all schemas in database raw to role transform;
grant select on all tables in database raw to role transform;
-- Grant ownership of existing objects in analytics database
grant ownership on all schemas in database analytics to role transform;
grant ownership on all tables in schema analytics.web to role transform;
grant ownership on all views in schema analytics.web to role transform;
grant ownership on all tables in schema analytics.titanic to role transform;
grant ownership on all views in schema analytics.titanic to role transform;


-- ####################################################################################################################
-- Grant appropriate privileges to read role
-- ####################################################################################################################
-- Grant usage of only the reader warehouse
grant usage on warehouse reader to role read;
-- Grant appropriate access to analytics database
grant usage on database analytics to role read;
grant usage on all schemas in database analytics to role read;
grant select on all views in schema analytics.web to role read;
grant select on all tables in schema analytics.web to role read;
grant select on all views in schema analytics.titanic to role read;
grant select on all tables in schema analytics.titanic to role read;


-- ####################################################################################################################
-- Future grants/privileges! The mechanism for hands-off database management!

-- Whenever schemas, tables, or views are created in the raw database, the transform role will
-- automatically have access.

-- Whenever schemas, tables, or views are created in the analytics database,
-- the read role will automatically have access.
-- ####################################################################################################################
-- Future grants within raw database to transform role
grant usage on future schemas in database raw to role transform;
grant select on future tables in database raw to role transform;
grant select on future views in database raw to role trasnform;

-- Future grants within analytics database to read role
grant usage on future schemas in database analytics to role read;
grant select on future tables in database analytics to role read;
grant select on future views in database analytics to role read;
