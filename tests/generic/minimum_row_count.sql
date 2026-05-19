{% test minimum_row_count(model, min_row_count) %}
SELECT count(*) as cnt FROM {{ model }} having count(*) < {{ min_row_count }}
{% endtest %}