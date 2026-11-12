{{ config(
    materialized='incremental',
    unique_key='CUSTOMER_ID',
    incremental_strategy='merge'
) }}

SELECT
    CUSTOMER_ID,
    DEFAULT_FLAG,
    -- Customer financial profile
    AGE,
    ANNUAL_INCOME,
    CREDIT_AMOUNT,
    ANNUITY_AMOUNT,
    GOODS_PRICE,
    -- Credit exposure
    TOTAL_BUREAU_ACCOUNTS,
    TOTAL_BUREAU_CREDIT,
    TOTAL_BUREAU_OUTSTANDING_DEBT,
    TOTAL_BUREAU_OVERDUE_AMOUNT,
    -- Loan application behavior
    TOTAL_PREVIOUS_APPLICATIONS,
    APPROVED_APPLICATIONS,
    REFUSED_APPLICATIONS,
    TOTAL_REQUESTED_AMOUNT,
    TOTAL_APPROVED_CREDIT,
    -- Repayment behavior
    TOTAL_INSTALLMENT_RECORDS,
    AVG_PAYMENT_DELAY_DAYS,
    LATE_PAYMENT_COUNT,
    TOTAL_UNPAID_AMOUNT,
    -- POS loan behavior
    TOTAL_POS_CASH_LOANS,
    OVERDUE_RECORD_COUNT,
    MAX_DAYS_PAST_DUE,
    -- Credit card behavior
    TOTAL_CREDIT_CARD_ACCOUNTS,
    AVG_CREDIT_CARD_BALANCE,
    AVG_CREDIT_LIMIT,
    AVG_CREDIT_UTILIZATION,
    TOTAL_DRAWINGS,
    TOTAL_PAYMENTS,
    OVERDUE_MONTH_RECORDS,

    -- Business metrics
    {{ debt_to_income_ratio('TOTAL_BUREAU_OUTSTANDING_DEBT', 'ANNUAL_INCOME') }}
        AS DEBT_TO_INCOME_RATIO,

    {{ loan_rejection_rate('REFUSED_APPLICATIONS', 'TOTAL_PREVIOUS_APPLICATIONS') }}
        AS LOAN_REJECTION_RATE,

    INSERTED_AT,
    UPDATED_AT

FROM {{ ref('int_customer_credit_profile') }}
