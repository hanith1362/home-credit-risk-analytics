{% macro loan_rejection_rate(refused_column, total_column) %}

    COALESCE(
        ROUND(
            {{ refused_column }} * 100.0 /
            NULLIF({{ total_column }}, 0),
            2
        ),
        0
    )

{% endmacro %}