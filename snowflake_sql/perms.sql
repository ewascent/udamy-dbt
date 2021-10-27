use warehouse PC_DBT_WH;

CREATE DATABASE analytics;
grant all on database analytics to role PC_DBT_ROLE;
-- done by DBT run 
-- CREATE SCHEMA analytics.DBT;
grant all on all schemas in database analytics to role PC_DBT_ROLE;
grant all on future schemas in database analytics to role PC_DBT_ROLE;
grant all on all tables in database analytics to role PC_DBT_ROLE;
grant all on future tables in database analytics to role PC_DBT_ROLE;
