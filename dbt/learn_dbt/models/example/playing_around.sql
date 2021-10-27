SELECT c_custkey, c_mktsegment, {{ rename_segments('c_mktsegment') }} AS c_mktsegment_adj
FROM {{ source('sample', 'customer') }}

