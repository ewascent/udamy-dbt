{% macro rename_segments(col) %}
  CASE
    WHEN {{ col }} in ('BUILDING', 'HOUSEHOLD', 'FURNITURE')
      THEN 'segment_1'
    ELSE 'segment_2'
  END
{% endmacro %}