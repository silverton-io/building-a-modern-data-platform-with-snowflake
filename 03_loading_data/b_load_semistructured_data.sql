-- ####################################################################################################################
-- Use the SYSADMIN role
-- ####################################################################################################################
use role sysadmin;


-- ####################################################################################################################
-- Use the load warehouse we previously created
-- ####################################################################################################################
use warehouse loader;


-- ####################################################################################################################
-- Load local json data into the raw.snowplow.load_stg internal stage.
-- ####################################################################################################################
put file:///ABSOLUTE_PATH_TO/building-a-modern-data-platform-with-snowflake/data/events.json.gz @raw.snowplow.load_stg/ auto_compress = true source_compression = gzip;


-- ####################################################################################################################
-- Examine LOAD_STG to check the staged file
-- ####################################################################################################################
ls @raw.snowplow.load_stg/;


-- ####################################################################################################################
-- Copy data from the raw.snowplow.load_stg internal stage into the raw.snowplow.events table.
-- ####################################################################################################################
copy into raw.snowplow.events from @raw.snowplow.load_stg/events.json.gz file_format = (type = json) match_by_column_name = case_insensitive purge = false;

-- Snowflake checkpoints files which have been loaded via COPY INTO behind the scenes.
-- COPY INTO is an idempotent operation, which means re-running the same exact command will not duplicate data.
-- Try it out!
copy into raw.snowplow.events from @raw.snowplow.load_stg/events.json.gz file_format = (type = json) match_by_column_name = case_insensitive purge = false;

-- +---------------------------------------+
-- | status                                |
-- |---------------------------------------|
-- | Copy executed with 0 files processed. |
-- +---------------------------------------+
-- 1 Row(s) produced. Time Elapsed: 2.718s
