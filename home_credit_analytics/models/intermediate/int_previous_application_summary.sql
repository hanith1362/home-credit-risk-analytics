
{{ config(materialized='view') }}

SELECT
    CUSTOMER_ID,
    -- Application counts
    COUNT(DISTINCT PREVIOUS_APPLICATION_ID)
        AS TOTAL_PREVIOUS_APPLICATIONS,
    COUNT_IF(CONTRACT_STATUS = 'Approved')
        AS APPROVED_APPLICATIONS,
    COUNT_IF(CONTRACT_STATUS = 'Refused')
        AS REFUSED_APPLICATIONS,
    -- Credit information
    SUM(COALESCE(APPLICATION_AMOUNT, 0))
        AS TOTAL_REQUESTED_AMOUNT,
    SUM(
        CASE
            WHEN CONTRACT_STATUS = 'Approved'
            THEN COALESCE(CREDIT_AMOUNT, 0)
            ELSE 0
        END
    ) AS TOTAL_APPROVED_CREDIT,

    AVG(APPLICATION_AMOUNT)
        AS AVG_REQUESTED_AMOUNT,
    -- Payment information
    AVG(ANNUITY_AMOUNT)
        AS AVG_ANNUITY_AMOUNT,
    AVG(PAYMENT_COUNT)
        AS AVG_PAYMENT_COUNT,
    -- Ingestion tracking
    MAX(INSERTED_AT) AS LATEST_INSERTED_AT,
    MAX(UPDATED_AT) AS LATEST_UPDATED_AT

FROM {{ ref('stg_previous_application') }}

GROUP BY CUSTOMER_ID
