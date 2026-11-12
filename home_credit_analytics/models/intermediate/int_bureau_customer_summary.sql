
{{ config(materialized='view') }}

WITH bureau_data AS (

    SELECT *
    FROM {{ ref('stg_bureau') }}

),

customer_summary AS (

    SELECT
        CUSTOMER_ID,
        COUNT(DISTINCT BUREAU_CREDIT_ID) AS TOTAL_BUREAU_ACCOUNTS,
        COUNT_IF(UPPER(CREDIT_STATUS) = 'ACTIVE')
            AS ACTIVE_BUREAU_ACCOUNTS,
        COUNT_IF(UPPER(CREDIT_STATUS) = 'CLOSED')
            AS CLOSED_BUREAU_ACCOUNTS,

        -- Credit exposure
        SUM(COALESCE(TOTAL_CREDIT_AMOUNT, 0))
            AS TOTAL_BUREAU_CREDIT,

        SUM(COALESCE(OUTSTANDING_DEBT, 0))
            AS TOTAL_BUREAU_OUTSTANDING_DEBT,

        SUM(COALESCE(OVERDUE_AMOUNT, 0))
            AS TOTAL_BUREAU_OVERDUE_AMOUNT,

        MAX(MAX_OVERDUE_AMOUNT)
            AS MAX_BUREAU_OVERDUE_AMOUNT,

        -- Data tracking
        MIN(INSERTED_AT) AS FIRST_INGESTED_AT,
        MAX(UPDATED_AT) AS LAST_UPDATED_AT

    FROM bureau_data
    GROUP BY CUSTOMER_ID
)

SELECT *
FROM customer_summary
