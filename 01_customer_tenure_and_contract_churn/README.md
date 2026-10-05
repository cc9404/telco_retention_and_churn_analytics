# 📄 Module 1: Customer Tenure & Contract Churn Dynamics

This module evaluates customer retention velocity and monthly recurring revenue (MRR) loss across customer tenure cohorts and contract structures using the IBM Telco dataset.

---

## 📌 Business Problem & Marketing Context

Acquisition marketing often prioritizes low-friction sign-ups via **Month-to-Month** contracts to hit volume targets. However, if new subscribers defect before offsetting Customer Acquisition Cost (CAC), company profitability rapidly deteriorates.

This analysis investigates:
1. **The "Danger Zone" Tenure Window:** Pinpointing when attrition peaks during the subscriber lifecycle.
2. **Contract-Level Revenue Erosion:** Measuring lost monthly recurring revenue across contractual commitments.
3. **Targeted CRM Interventions:** Determining exact milestones for automated onboarding check-ins and contract migration incentives.

---

## 🛠 SQL Script & Analytical Pipeline

* **Main SQL Script:** 🔗 [`customer_tenure_and_contract_churn.sql`](./customer_tenure_and_contract_churn.sql)
* **Final Output Data:** 📄 [`final_output.csv`](./final_output.csv)

### 🔹 Methodology
* **Tenure Cohort Partitioning:** Group `Tenure Months` into 6 lifecycle stages (`00-06 Months`, `07-12 Months`, `13-24 Months`, `25-36 Months`, `37-48 Months`, `49+ Months`).
* **Financial Aggregation:** Calculate churn counts (`Churn Value = 1`), cohort-level churn rates, total monthly billing, and lost MRR.

```sql
USE telco_analytics;

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
```
---

## 📊 Summary Performance Comparison (`final_output.csv`)

* **Source File:** 📄 [`final_output.csv`](./final_output.csv)

| contract | tenure_cohort | total_customers | churned_customers | churn_rate | total_monthly_revenue | lost_monthly_revenue | avg_monthly_charge |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Month-to-month** | **00-06 Months** | **1,413** | **780** | **55.20%** | **$78,954.40** | **$49,681.30** | $55.88 |
| **Month-to-month** | 07-12 Months | 581 | 244 | 42.00% | $37,132.10 | $18,620.20 | $63.91 |
| **Month-to-month** | 13-24 Months | 737 | 278 | 37.72% | $51,081.20 | $21,980.30 | $69.31 |
| **Month-to-month** | 25-36 Months | 486 | 158 | 32.51% | $36,122.60 | $13,417.00 | $74.33 |
| **Month-to-month** | 37-48 Months | 316 | 106 | 33.54% | $24,781.50 | $9,140.05 | $78.42 |
| **Month-to-month** | 49+ Months | 342 | 89 | 26.02% | $29,222.50 | $8,008.35 | $85.45 |
| **One year** | 00-06 Months | 38 | 4 | 10.53% | $1,047.05 | $214.80 | $27.55 |
| **One year** | 07-12 Months | 85 | 9 | 10.59% | $3,372.15 | $438.00 | $39.67 |
| **One year** | 13-24 Months | 197 | 16 | 8.12% | $8,841.10 | $1,101.35 | $44.88 |
| **One year** | 25-36 Months | 250 | 20 | 8.00% | $14,524.70 | $1,701.75 | $58.10 |
| **One year** | 37-48 Months | 268 | 35 | 13.06% | $17,568.60 | $2,819.60 | $65.55 |
| **One year** | 49+ Months | 634 | 82 | 12.93% | $50,443.30 | $7,842.95 | $79.56 |
| **Two year** | 00-06 Months | 19 | 0 | 0.00% | $610.90 | $0.00 | $32.15 |
| **Two year** | 07-12 Months | 39 | 0 | 0.00% | $1,057.55 | $0.00 | $27.12 |
| **Two year** | 13-24 Months | 90 | 0 | 0.00% | $2,907.60 | $0.00 | $32.31 |
| **Two year** | 25-36 Months | 96 | 2 | 2.08% | $3,911.55 | $49.25 | $40.75 |
| **Two year** | 37-48 Months | 178 | 4 | 2.25% | $8,184.40 | $334.90 | $45.98 |
| **Two year** | 49+ Months | 1,263 | 42 | 3.33% | $85,897.90 | $3,781.15 | $68.01 |

---

## 💡 Key Business Insights & Strategic Recommendations

1. **The Critical 0–6 Month Onboarding Cliff:**
   * Month-to-Month accounts suffer a staggering **55.20% churn rate** within the first 6 months, leaking **$49,681.30/month** in recurring billing. This single cohort accounts for nearly 40% of all churned revenue across the entire subscriber base.
2. **Contract Length as a Structural Retention Shield:**
   * Annual commitments suppress churn dramatically: One-Year contracts maintain churn under **13.1%**, while Two-Year contracts exhibit virtual zero churn during the first 24 months (0.00%) and stabilize at just **3.33%** long-term.
3. **Actionable Lifecycle Marketing Interventions:**
   * **Days 30–60 Proactive Engagement:** Trigger automated onboarding workflows, satisfaction surveys, and customer success check-ins specifically targeting Month-to-Month users prior to their 90-day mark.
   * **Month 3 Contract Migration Offer:** Deliver targeted promotional bill credits (e.g., $10 off for 6 months) to incentivize high-performing Month-to-Month users to lock into a 1-year contract before hitting the Month 6 cliff.
