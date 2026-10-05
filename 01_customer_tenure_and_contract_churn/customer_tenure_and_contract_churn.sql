USE telco_analytics;
SELECT * FROM telco_customer_churn;

WITH customer_cohort_base AS (
    SELECT
        `CustomerID`,
        `Contract`,
        `Payment Method` AS payment_method,
        `Tenure Months` AS tenure_months,
        `Monthly Charges` AS monthly_charges,
        `Churn Value` AS churn_value,
        CASE
            WHEN `Tenure Months` <= 6 THEN '00-06 Months'
            WHEN `Tenure Months` <= 12 THEN '07-12 Months'
            WHEN `Tenure Months` <= 24 THEN '13-24 Months'
            WHEN `Tenure Months` <= 36 THEN '25-36 Months'
            WHEN `Tenure Months` <= 48 THEN '37-48 Months'
            ELSE '49+ Months'
        END AS tenure_cohort
    FROM telco_customer_churn
)
SELECT
    `Contract` AS contract,
    tenure_cohort,
    COUNT(`CustomerID`) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(SUM(churn_value) / COUNT(`CustomerID`), 4) AS churn_rate,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS lost_monthly_revenue,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge
FROM customer_cohort_base
GROUP BY 1, 2
ORDER BY 
    CASE 
        WHEN `Contract` LIKE 'Month%' THEN 1
        WHEN `Contract` LIKE 'One%' THEN 2
        WHEN `Contract` LIKE 'Two%' THEN 3
        ELSE 4
    END,
    tenure_cohort ASC;