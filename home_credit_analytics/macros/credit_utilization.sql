
{% macro credit_utilization(balance_column, limit_column) %}

    ROUND(
        ({{ balance_column }} / NULLIF({{ limit_column }}, 0)) * 100,
        2
    )

{% endmacro %}
