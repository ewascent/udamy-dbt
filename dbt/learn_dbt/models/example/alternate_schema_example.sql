{{ config(materialized='table', alias='table_one', schema='bubba') }}

SELECT 'Wallace' AS Name
UNION
SELECT 'Gump' AS Name