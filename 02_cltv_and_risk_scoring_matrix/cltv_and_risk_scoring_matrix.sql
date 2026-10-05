USE telco_analytics;
SELECT * FROM telco_customer_churn;

WITH scored_customers AS (
    SELECT
        `CustomerID`,
        `Contract`,
        `Tenure Months` AS tenure_months,
        `Monthly Charges` AS monthly_charges,
        `Total Charges` AS total_charges,
        `CLTV` AS cltv,
        `Churn Score` AS churn_score,
        `Churn Value` AS churn_value,
        NTILE(3) OVER(ORDER BY `CLTV` ASC) AS cltv_tier_num,
        NTILE(3) OVER(ORDER BY `Churn Score` ASC) AS risk_tier_num
    FROM telco_customer_churn
),
labeled_segments AS (
    SELECT
        `CustomerID`,
        tenure_months,
        monthly_charges,
        total_charges,
        cltv,
        churn_score,
        churn_value,
        CASE cltv_tier_num
            WHEN 1 THEN 'Low CLTV'
            WHEN 2 THEN 'Mid CLTV'
            WHEN 3 THEN 'High CLTV'
        END AS cltv_tier,
        CASE risk_tier_num
            WHEN 1 THEN 'Low Risk'
            WHEN 2 THEN 'Medium Risk'
            WHEN 3 THEN 'High Risk'
        END AS risk_tier,
        CASE
            WHEN cltv_tier_num = 3 AND risk_tier_num = 3 THEN 'Priority 1: VIP Flight Risk (Defend)'
            WHEN cltv_tier_num = 3 AND risk_tier_num = 2 THEN 'Priority 2: VIP Watchlist'
            WHEN cltv_tier_num = 3 AND risk_tier_num = 1 THEN 'Priority 3: Loyal Champions'
            WHEN cltv_tier_num = 2 AND risk_tier_num = 3 THEN 'Priority 4: Mid-Value High Risk'
            WHEN cltv_tier_num = 2 AND risk_tier_num = 2 THEN 'Priority 5: Mid-Value Core'
            WHEN cltv_tier_num = 2 AND risk_tier_num = 1 THEN 'Priority 6: Stable Mid-Value'
            WHEN cltv_tier_num = 1 AND risk_tier_num = 3 THEN 'Priority 7: Low-Value Churn Risk'
            WHEN cltv_tier_num = 1 AND risk_tier_num = 2 THEN 'Priority 8: Low-Value Moderate'
            ELSE 'Priority 9: Low-Value Low Risk'
        END AS strategic_segment
    FROM scored_customers
)
SELECT
    strategic_segment,
    cltv_tier,
    risk_tier,
    COUNT(`CustomerID`) AS customer_count,
    ROUND(COUNT(`CustomerID`) / SUM(COUNT(`CustomerID`)) OVER(), 4) AS pct_of_base,
    ROUND(AVG(cltv), 2) AS avg_cltv,
    ROUND(AVG(churn_score), 2) AS avg_churn_score,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_revenue_at_risk,
    ROUND(SUM(churn_value) / COUNT(`CustomerID`), 4) AS actual_churn_rate
FROM labeled_segments
GROUP BY 1, 2, 3
ORDER BY 
    CASE cltv_tier WHEN 'High CLTV' THEN 1 WHEN 'Mid CLTV' THEN 2 ELSE 3 END,
    CASE risk_tier WHEN 'High Risk' THEN 1 WHEN 'Medium Risk' THEN 2 ELSE 3 END;