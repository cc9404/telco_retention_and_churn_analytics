# 📄 Module 4: Value-Added Services & Retention Strategy

This module measures the strategic retention lift and revenue expansion driven by cross-selling 6 digital add-on services (**Online Security, Online Backup, Device Protection, Tech Support, Streaming TV, Streaming Movies**) across active internet subscribers.

---

## 📌 Business Problem & Marketing Context

Acquiring single-play broadband customers leaves a business exposed to aggressive competitor price poaching. In subscription lifecycle marketing, cross-selling value-added services serves a dual purpose:
1. **ARPU & Revenue Expansion:** Lifting customer recurring charges through incremental monthly fees.
2. **Switching Cost & Retention Moats:** Integrating security, backup, and technical assistance deeply into the customer's daily workflow, creating structural friction against defection.

This module evaluates:
* **Add-On Saturation:** How customer churn probability changes as subscribers adopt from 0 up to 6 add-on services.
* **Anchor Retention Features:** The penetration and retention impact of high-utility features (`Tech Support` and `Online Security`).
* **Packaging Recommendations:** Evidence-based bundling strategies for introductory and cross-sell marketing campaigns.

---

## 🛠 SQL Script & Analytical Pipeline

* **Main SQL Script:** 🔗 [`value_added_services_retention.sql`](./value_added_services_retention.sql)
* **Final Output Data:** 📄 [`final_output.csv`](./final_output.csv)

### 🔹 Methodology
* **Broadband Cohort Scope:** Filter for subscribers with active internet connections (`Internet Service != 'No'`), as non-internet customers cannot adopt digital add-ons.
* **Add-on Density Scoring:** Calculate the sum of 6 active binary services per account.
* **Service Tiering:** Aggregate subscribers into 4 bundle tiers (`0 Add-ons`, `1-2 Add-ons`, `3-4 Add-ons`, `5-6 Add-ons`) to observe churn elasticity against add-on density.

```sql
WITH add_on_base AS (
    SELECT
        `CustomerID`,
        `Internet Service` AS internet_service,
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
    WHERE `Internet Service` != 'No'
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

```

---

## 📊 Summary Performance Comparison (`final_output.csv`)

* **Source File:** 📄 [`final_output.csv`](./final_output.csv)

| service_bundle_tier | total_add_ons | total_customers | churned_customers | churn_rate | avg_monthly_charge | security_penetration | tech_support_penetration |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0 Add-ons (Core Internet Only)** | 0 | 693 | 362 | **52.24%** | $58.59 | 0.00% | 0.00% |
| **1-2 Add-ons (Basic Bundle)** | 1 | 966 | 442 | 45.76% | $65.57 | 18.12% | 10.56% |
| **1-2 Add-ons (Basic Bundle)** | 2 | 1,033 | 370 | 35.82% | $72.42 | 28.56% | 25.65% |
| **3-4 Add-ons (Intermediate)** | 3 | 1,117 | 306 | 27.39% | $80.13 | 40.47% | 39.03% |
| **3-4 Add-ons (Intermediate)** | 4 | 850 | 190 | 22.35% | $87.83 | 48.12% | 55.88% |
| **5-6 Add-ons (Full Ecosystem)** | 5 | 569 | 71 | 12.48% | $92.26 | 70.30% | 84.01% |
| **5-6 Add-ons (Full Ecosystem)** | 6 | 284 | 15 | **5.28%** | $99.37 | 100.00% | 100.00% |

---

## 💡 Key Business Insights & Strategic Recommendations

1. **The Ecosystem Moat (10x Churn Reduction):**
   * Customer churn exhibits a steep negative correlation with value-added service density. Single-play broadband subscribers (`0 Add-ons`) suffer a catastrophic **52.24% churn rate**. As customers adopt digital services, churn systematically plummets to **22.35%** at 4 add-ons and bottoms out at just **5.28%** for full-ecosystem users (6 add-ons)—a nearly **10x reduction in defection risk**.

2. **Dual-Engine Revenue & Retention Expansion:**
   * Expanding from 0 add-ons ($58.59/mo) to 6 add-ons ($99.37/mo) expands Average Revenue Per User (ARPU) by **+69.6% ($40.78 incremental MRR/sub)** while simultaneously stabilizing cash flows. Adding services creates operational and technical switching costs that insulate the customer from competitor promotions.

3. **Tech Support & Online Security as Critical Retention Anchors:**
   * In the high-retention cohorts (5–6 add-ons), `Tech Support` penetration reaches **84.01% – 100.00%** and `Online Security` reaches **70.30% – 100.00%**, compared to only 10.56% and 18.12% in the 1-add-on tier. These two utility services directly resolve technical friction and device vulnerabilities, removing the #1 churn driver identified in Module 3 (support/service dissatisfaction).

4. **Actionable Go-To-Market Packaging Strategy:**
   * **Introductory Tri-Play Bundling:** Discontinue the marketing of unbundled standalone internet plans. Instead, automatically bundle `Online Security` and `Tech Support` free for the first 90 days into all new subscriptions to breach the 2-add-on threshold during the dangerous 0–6 month onboarding cliff.
   * **Post-Onboarding Cross-Sell Drips:** At Month 3, trigger targeted automated in-app notifications and promotional credits for cloud storage (`Online Backup`) and entertainment add-ons to move subscribers from the 1–2 tier into the sticky 3+ tier.

