-- ####################################################################################################################
-- Use the USERADMIN role
-- ####################################################################################################################
use role useradmin;


-- ####################################################################################################################
-- Create load user(s)
-- ####################################################################################################################
create user loader
    login_name = 'loader'
    display_name = 'loader'
    password = 'changeme!'
    must_change_password = false
    comment = 'A programmatic user for loading data'
    default_warehouse = loader
    default_role = load;

-- create user stitch .....
-- create user fivetran .....


-- ####################################################################################################################
-- Create transform user(s)
-- ####################################################################################################################
create user transformer
    login_name = 'transformer'
    display_name = 'transformer'
    password = 'ChangeME2!'
    must_change_password = false
    comment = 'A programmatic user for transforming data'
    default_warehouse = transformer
    default_role = transform;

-- create user dbt...   -> https://www.getdbt.com/
-- create user structure_rest...   -> https://www.structure.rest/
-- create user dataform...   -> https://dataform.co/


-- ####################################################################################################################
-- Create viz user(s)
-- ####################################################################################################################
create user reader
    login_name = 'reader'
    display_name = 'reader'
    password = 'chgmplz#4'
    must_change_password = false
    comment = 'A programmatic user for reading analytics data'
    default_warehouse = reader
    default_role = read;

-- create user looker...
-- create user tableau...
-- create user metabase...
-- create user mode...


-- ####################################################################################################################
-- To view what we've just created
-- ####################################################################################################################
show users;


-- ####################################################################################################################
-- To clean up what we've just created
-- ####################################################################################################################
drop user if exists loader;
drop user if exists transformer;
drop user if exists reader;
