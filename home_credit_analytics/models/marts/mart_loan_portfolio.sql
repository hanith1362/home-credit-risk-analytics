
{{ config(materialized='table') }}

SELECT
    CUSTOMER_ID,
    DEFAULT_FLAG,
    -- Loan application volume
    TOTAL_PREVIOUS_APPLICATIONS,
    APPROVED_APPLICATIONS,
    REFUSED_APPLICATIONS,

    -- Application amounts
    TOTAL_REQUESTED_AMOUNT,
    TOTAL_APPROVED_CREDIT,
    AVG_REQUESTED_AMOUNT,
    AVG_ANNUITY_AMOUNT,
    AVG_PAYMENT_COUNT,

    -- Portfolio performance metrics
    ROUND(
        APPROVED_APPLICATIONS * 100.0 /
        NULLIF(TOTAL_PREVIOUS_APPLICATIONS, 0),
        2
    ) AS APPROVAL_RATE,

    {{ loan_rejection_rate('REFUSED_APPLICATIONS', 'TOTAL_PREVIOUS_APPLICATIONS') }}
        AS REFUSAL_RATE,
    
    {{credit_utilization('TOTAL_APPROVED_CREDIT','Approved_applications')}}
    as AVG_APPROVED_CREDIT,


    -- Customer financial context
    ANNUAL_INCOME,
    CREDIT_AMOUNT,
    ANNUITY_AMOUNT,
    AGE,

    INSERTED_AT,
    UPDATED_AT

FROM {{ ref('int_customer_credit_profile') }}
