SELECT SUM(CASE WHEN id IS NULL THEN 1 else 0 END) / count(*) as total_nulls
FROM {{ ref('my_first_dbt_model') }}
HAVING  total_nulls > .6