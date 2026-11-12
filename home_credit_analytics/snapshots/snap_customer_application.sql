
{% snapshot snap_customer_application %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='CUSTOMER_ID',
        strategy='check',
        check_cols=[
            'ANNUAL_INCOME',
            'CREDIT_AMOUNT',
            'ANNUITY_AMOUNT',
            'GOODS_PRICE'
        ]
    )
}}

SELECT
    CUSTOMER_ID,
    DEFAULT_FLAG,
    ANNUAL_INCOME,
    CREDIT_AMOUNT,
    ANNUITY_AMOUNT,
    GOODS_PRICE,
    AGE

FROM {{ ref('stg_application_train') }}

{% endsnapshot %}
