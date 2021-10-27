{{ config(materialized='incremental', unique_key='id') }}

SELECT
       to_time(concat(T_HOUR::varchar, ':', T_MINUTE, ':', T_SECOND)) AS id,
       T_TIME_SK,
       T_TIME_ID,
       T_TIME,
       T_HOUR,
       T_MINUTE,
       T_SECOND,
       T_AM_PM,
       T_SHIFT,
       T_SUB_SHIFT,
       T_MEAL_TIME
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCDS_SF10TCL"."TIME_DIM"
WHERE id <=  current_time


{% if is_incremental() %}
    and id     > (select max(id) from {{ this }})
{% endif %}
