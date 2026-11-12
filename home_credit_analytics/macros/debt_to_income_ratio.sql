{% macro debt_to_income_ratio(debt_column, income_column) %}

    ROUND(
        {{ debt_column }} / NULLIF({{ income_column }}, 0),
        4
    )

{% endmacro %}