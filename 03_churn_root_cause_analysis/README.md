# 📄 Module 3: Churn Root Cause Analysis

This module evaluates customer defection triggers by mapping granular **Churn Reasons** into 5 strategic business pillars, ranking attrition drivers by subscriber volume and lost monthly recurring revenue (MRR).

---

## 📌 Business Problem & Marketing Context

Effective customer retention requires knowing the exact points of dissatisfaction. Blanket retention initiatives fail when marketing cannot distinguish between pricing sensitivity, product performance bottlenecks, and service-level friction.

This diagnostic analysis evaluates:
1. **Primary Defection Triggers:** Which specific friction points account for the highest volume of lost subscribers.
2. **Category-Level Revenue Exposure:** The financial magnitude of lost monthly billing across Competitor, Support, Product Quality, and Pricing dimensions.
3. **Cross-Departmental Remediation:** Strategic interventions across product marketing, network operations, and frontline customer service.

---

## 🛠 SQL Script & Analytical Pipeline

* **Main SQL Script:** 🔗 [`churn_root_cause_analysis.sql`](./churn_root_cause_analysis.sql)
* **Final Output Data:** 📄 [`final_output.csv`](./final_output.csv)

### 🔹 Methodology
* **Population Filtering:** Isolate departed accounts (`Churn Value = 1`).
* **Categorical Mapping:** Apply `CASE WHEN` pattern matching to classify raw churn reasons into 5 strategic marketing dimensions (`Competitor Threat`, `Customer Service & Support`, `Pricing & Financial Friction`, `Product & Network Quality`, `Personal & Other Reasons`).
* **Pareto Ranking & Share of Churn:** Use `DENSE_RANK() OVER(ORDER BY COUNT(CustomerID) DESC)` and Window Aggregations to determine the overall volume hierarchy and proportional revenue loss.

```sql
USE telco_analytics;

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

```

---

## 📊 Summary Performance Comparison (`final_output.csv`)

* **Source File:** 📄 [`final_output.csv`](./final_output.csv)

### 🔹 Strategic Churn Category Aggregation

| Strategic Churn Category | Churned Customers | % of Total Churn | Total Lost Monthly Revenue |
| :--- | :---: | :---: | :---: |
| **Competitor Threat** | **621** | **33.23%** | **$46,600.80** |
| **Customer Service & Support** | **587** | **31.40%** | **$43,288.20** |
| **Personal & Other Reasons** | 315 | 16.86% | $23,169.30 |
| **Pricing & Financial Friction** | 199 | 10.64% | $15,389.90 |
| **Product & Network Quality** | 147 | 7.86% | $10,682.60 |

---

### 🔹 Granular Churn Reason Ranking Table

| overall_reason_rank | churn_reason | derived_churn_category | churned_customer_count | pct_of_total_churn | total_lost_monthly_revenue | avg_monthly_charge_lost |
| :---: | :--- | :--- | :---: | :---: | :---: | :---: |
| **1** | Attitude of support person | Customer Service & Support | 192 | 10.27% | $13,980.85 | $72.82 |
| **2** | Competitor offered higher download speeds | Competitor Threat | 189 | 10.11% | $14,144.60 | $74.84 |
| **3** | Competitor offered more data | Competitor Threat | 162 | 8.67% | $12,351.75 | $76.25 |
| **4** | Don't know | Personal & Other Reasons | 154 | 8.24% | $11,099.05 | $72.07 |
| **5** | Competitor made better offer | Competitor Threat | 140 | 7.49% | $10,672.10 | $76.23 |
| **6** | Attitude of service provider | Customer Service & Support | 135 | 7.22% | $10,399.30 | $77.03 |
| **7** | Competitor had better devices | Competitor Threat | 130 | 6.96% | $9,432.35 | $72.56 |
| **8** | Network reliability | Product & Network Quality | 103 | 5.51% | $7,497.55 | $72.79 |
| **9** | Product dissatisfaction | Personal & Other Reasons | 102 | 5.46% | $7,528.65 | $73.81 |
| **10** | Price too high | Pricing & Financial Friction | 98 | 5.24% | $7,398.55 | $75.50 |
| **11** | Service dissatisfaction | Customer Service & Support | 89 | 4.76% | $6,733.25 | $75.65 |
| **12** | Lack of self-service on Website | Customer Service & Support | 88 | 4.71% | $6,349.65 | $72.16 |
| **13** | Extra data charges | Pricing & Financial Friction | 57 | 3.05% | $4,543.40 | $79.71 |
| **14** | Moved | Personal & Other Reasons | 53 | 2.84% | $4,131.00 | $77.94 |
| **15** | Limited range of services | Customer Service & Support | 44 | 2.35% | $3,025.25 | $68.76 |
| **15** | Lack of affordable download/upload speed | Product & Network Quality | 44 | 2.35% | $3,185.05 | $72.39 |
| **15** | Long distance charges | Pricing & Financial Friction | 44 | 2.35% | $3,447.90 | $78.36 |
| **16** | Poor expertise of phone support | Customer Service & Support | 20 | 1.07% | $1,443.30 | $72.16 |
| **17** | Poor expertise of online support | Customer Service & Support | 19 | 1.02% | $1,356.65 | $71.40 |
| **18** | Deceased | Personal & Other Reasons | 6 | 0.32% | $410.65 | $68.44 |

---

## 💡 Key Business Insights & Strategic Recommendations

1. **Competitor Predation Drives Nearly 35% of Revenue Bleed:**
   * Competitor-driven defection (`Competitor Threat`) is the single largest category, capturing **621 subscribers (33.23% of churned base)** and eroding **$46,600.80 in lost MRR**. The primary competitive vectors are higher download speeds (189 accounts) and larger data allocations (162 accounts).
   * **Action:** Launch proactive broadband tier speed upgrades and data-tier rebalancing campaigns targeting high-usage accounts before their contract renewal window opens.

2. **Customer Service Attitude as the Single Largest Discrete Churn Cause:**
   * Rank #1 overall churn reason is **"Attitude of support person"** (192 lost customers, $13,980.85/month lost MRR), followed closely by "Attitude of service provider" (Rank #6, 135 lost customers, $10,399.30/month). Combined, support experience friction accounts for **$43,288.20/month** in avoidable leakage.
   * **Action:** Implement immediate CSAT and post-call sentiment scoring triggers. Any customer logging a service friction score below 3/5 must be automatically routed to a specialized retention resolution queue within 24 hours.

3. **Digital Self-Service Bottlenecks:**
   * Rank #12 highlights **"Lack of self-service on Website"** (88 customers, $6,349.65/month MRR), indicating customer frustration with routine administrative tasks like plan modifications or billing inquiries.
   * **Action:** Enhance mobile app and web portal account management capabilities to empower self-service resolution and eliminate unnecessary agent call-center friction.


