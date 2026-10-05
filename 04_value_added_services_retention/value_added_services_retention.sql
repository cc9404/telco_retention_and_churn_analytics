USE telco_analytics;
SELECt * FROM telco_customer_churn;

WITH add_on_base AS (
    SELECT
        `CustomerID`,
        `Internet Service` AS internet_service,
        `Contract` AS contract,
        `Monthly Charges` AS monthly_charges,
        `Churn Value` AS churn_value,
        `Online Security` AS online_security,
        `Online Backup` AS online_backup,
        `Device Protection` AS device_protection,
        `Tech Support` AS tech_support,
        `Streaming TV` AS streaming_tv,
        `Streaming Movies` AS streaming_movies,
        (
            CASE WHEN `Online Security` = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN `Online Backup` = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN `Device Protection` = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN `Tech Support` = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN `Streaming TV` = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN `Streaming Movies` = 'Yes' THEN 1 ELSE 0 END
        ) AS total_add_ons
    FROM telco_customer_churn
    WHERE `Internet Service` != 'No' -- Focus on internet-subscribing accounts capable of adopting digital add-ons
),
bundle_tiering AS (
    SELECT
        *,
        CASE
            WHEN total_add_ons = 0 THEN '0 Add-ons (Core Internet Only)'
            WHEN total_add_ons BETWEEN 1 AND 2 THEN '1-2 Add-ons (Basic Bundle)'
            WHEN total_add_ons BETWEEN 3 AND 4 THEN '3-4 Add-ons (Intermediate)'
            ELSE '5-6 Add-ons (Full Ecosystem)'
        END AS service_bundle_tier
    FROM add_on_base
)
SELECT
    service_bundle_tier,
    total_add_ons,
    COUNT(`CustomerID`) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(SUM(churn_value) / COUNT(`CustomerID`), 4) AS churn_rate,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END) / COUNT(`CustomerID`), 4) AS security_penetration,
    ROUND(SUM(CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END) / COUNT(`CustomerID`), 4) AS tech_support_penetration
FROM bundle_tiering
GROUP BY service_bundle_tier, total_add_ons
ORDER BY total_add_ons ASC;