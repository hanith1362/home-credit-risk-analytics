
{{ config(materialized='view') }}

SELECT
    SK_ID_BUREAU AS BUREAU_CREDIT_ID,

    MONTHS_BALANCE AS MONTH_OFFSET,

    STATUS AS MONTHLY_CREDIT_STATUS,
    INSERTED_AT,
    UPDATED_AT

FROM {{ source('home_credit_raw', 'BUREAU_BALANCE') }}
