USE telco_analytics;
SELECT * FROM telco_customer_churn;

WITH churned_population AS (
    SELECT
        `CustomerID`,
        `Churn Reason` AS churn_reason,
        `Internet Service` AS internet_service,
        `Contract` AS contract,
        `Monthly Charges` AS monthly_charges,
        `Total Charges` AS total_charges,
        CASE
            WHEN `Churn Reason` LIKE '%Competitor%' THEN 'Competitor Threat'
            WHEN `Churn Reason` LIKE '%Price%' OR `Churn Reason` LIKE '%charges%' OR `Churn Reason` LIKE '%Expensive%' THEN 'Pricing & Financial Friction'
            WHEN `Churn Reason` LIKE '%Attitude%' OR `Churn Reason` LIKE '%support%' OR `Churn Reason` LIKE '%Service%' THEN 'Customer Service & Support'
            WHEN `Churn Reason` LIKE '%network%' OR `Churn Reason` LIKE '%Device%' OR `Churn Reason` LIKE '%Reliability%' OR `Churn Reason` LIKE '%Speed%' THEN 'Product & Network Quality'
            ELSE 'Personal & Other Reasons'
        END AS derived_churn_category
    FROM telco_customer_churn
    WHERE `Churn Value` = 1
),
reason_aggregated AS (
    SELECT
        churn_reason,
        derived_churn_category,
        COUNT(`CustomerID`) AS churned_customer_count,
        ROUND(SUM(monthly_charges), 2) AS total_lost_monthly_revenue,
        ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge_lost,
        ROUND(COUNT(`CustomerID`) / SUM(COUNT(`CustomerID`)) OVER(), 4) AS pct_of_total_churn,
        DENSE_RANK() OVER(ORDER BY COUNT(`CustomerID`) DESC) AS overall_reason_rank
    FROM churned_population
    GROUP BY churn_reason, derived_churn_category
)
SELECT
    overall_reason_rank,
    churn_reason,
    derived_churn_category,
    churned_customer_count,
    pct_of_total_churn,
    total_lost_monthly_revenue,
    avg_monthly_charge_lost
FROM reason_aggregated
ORDER BY overall_reason_rank ASC;