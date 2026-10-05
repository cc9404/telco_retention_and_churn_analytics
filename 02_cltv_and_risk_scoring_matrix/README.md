# 📄 Module 2: CLTV & Risk Scoring Matrix

This module builds a $3 \times 3$ value-versus-risk segmentation framework using SQL Window Functions (`NTILE`), evaluating Customer Lifetime Value (CLTV) against predictive Churn Score percentiles across all 7,043 customer accounts.

---

## 📌 Business Problem & Marketing Context

Blanket customer retention campaigns (e.g., universal discounting, mass promotional emails) erode gross margins on low-value users while failing to provide high-touch protection for top-tier revenue drivers. 

Retention and CRM marketing teams require a prioritized triage model to answer:
1. **VIP Exposure:** How many high-CLTV subscribers fall into the highest churn risk bucket, and what is their recurring monthly revenue exposure?
2. **Defensive Budget Allocation:** How should retention spend (dedicated account reps vs. automated email flows) be divided across strategic tiers?
3. **Validation of Risk Indicators:** How accurately does the predictive `Churn Score` align with empirical account churn rates across value tiers?

---

## 🛠 SQL Script & Analytical Pipeline

* **Main SQL Script:** 🔗 [`cltv_and_risk_scoring_matrix.sql`](./cltv_and_risk_scoring_matrix.sql)
* **Final Output Data:** 📄 [`final_output.csv`](./final_output.csv)

### 🔹 Methodology
* **Window Percentiles:** Apply `NTILE(3) OVER(ORDER BY CLTV ASC)` and `NTILE(3) OVER(ORDER BY Churn Score ASC)` to construct objective 3-tier value and risk boundaries.
* **Segment Taxonomies:** Map the intersecting tiers into 9 prioritized strategic cohorts, ranking from `Priority 1: VIP Flight Risk (Defend)` to `Priority 9: Low-Value Low Risk`.
* **Revenue Exposure Metrics:** Quantify customer volume, average CLTV, average monthly charges, total MRR at risk, and actual empirical churn rates.

```sql
WITH scored_customers AS (
    SELECT
        `CustomerID`,
        `CLTV` AS cltv,
        `Churn Score` AS churn_score,
        `Churn Value` AS churn_value,
        `Monthly Charges` AS monthly_charges,
        NTILE(3) OVER(ORDER BY `CLTV` ASC) AS cltv_tier_num,
        NTILE(3) OVER(ORDER BY `Churn Score` ASC) AS risk_tier_num
    FROM telco_customer_churn
),
labeled_segments AS (
    SELECT
        *,
        CASE cltv_tier_num WHEN 1 THEN 'Low CLTV' WHEN 2 THEN 'Mid CLTV' ELSE 'High CLTV' END AS cltv_tier,
        CASE risk_tier_num WHEN 1 THEN 'Low Risk' WHEN 2 THEN 'Medium Risk' ELSE 'High Risk' END AS risk_tier,
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
```

---

## 📊 Summary Performance Comparison

* **Source File:** 📄 [`final_output.csv`](./final_output.csv)

| strategic_segment | cltv_tier | risk_tier | customer_count | pct_of_base | avg_cltv | avg_churn_score | avg_monthly_charge | total_monthly_revenue_at_risk | actual_churn_rate |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Priority 1: VIP Flight Risk (Defend)** | High CLTV | High Risk | 713 | 10.14% | $5,650.33 | 81.30 | $71.32 | $50,848.85 | **57.92%** |
| **Priority 2: VIP Watchlist** | High CLTV | Medium Risk | 812 | 11.55% | $5,703.33 | 59.87 | $66.85 | $54,285.75 | 10.59% |
| **Priority 3: Loyal Champions** | High CLTV | Low Risk | 819 | 11.65% | $5,669.27 | 33.57 | $64.96 | $53,200.40 | 0.00% |
| **Priority 4: Mid-Value High Risk** | Mid CLTV | High Risk | 742 | 10.55% | $4,550.13 | 82.18 | $70.83 | $52,559.10 | 63.75% |
| **Priority 5: Mid-Value Core** | Mid CLTV | Medium Risk | 780 | 11.09% | $4,527.98 | 60.09 | $65.56 | $51,133.60 | 11.54% |
| **Priority 6: Stable Mid-Value** | Mid CLTV | Low Risk | 822 | 11.69% | $4,541.39 | 32.93 | $62.45 | $51,330.30 | 0.00% |
| **Priority 7: Low-Value Churn Risk** | Low CLTV | High Risk | 889 | 12.64% | $3,000.89 | 83.17 | $67.43 | $59,943.40 | **72.67%** |
| **Priority 8: Low-Value Moderate** | Low CLTV | Medium Risk | 752 | 10.69% | $2,979.35 | 61.58 | $58.87 | $44,267.10 | 21.41% |
| **Priority 9: Low-Value Low Risk** | Low CLTV | Low Risk | 703 | 10.00% | $2,985.40 | 33.63 | $54.19 | $38,092.60 | 0.00% |

---

## 💡 Key Business Insights & Strategic Recommendations

1. **High-Stakes Exposure in Priority 1 (VIP Flight Risk):**
   * There are **713 VIP customers** in the high-CLTV and high-risk quadrant, generating **$50,848.85** in monthly recurring billing with an actual attrition rate of **57.92%**. 
   * **Action:** Because each subscriber represents over $5,600 in lifetime value, marketing and retention teams should allocate dedicated outbound success calls, executive check-ins, and proactive device/service upgrades before contractual friction leads to cancellation.

2. **Empirical Validation of the Risk Scoring Model:**
   * Across all CLTV tiers, the predictive `Churn Score` proves highly reliable: accounts in the **Low Risk** bucket exhibit an actual churn rate of **0.00%**, while the **High Risk** bucket spikes to **57.92% – 72.67%**. This validates the score as an effective automated gating trigger for lifecycle workflows.

3. **Cost-Effective Triage for Priority 7 (Low-Value High-Risk):**
   * Priority 7 contains 889 customers with a **72.67% churn rate**, but an average CLTV of only $3,000.89. 
   * **Action:** High-touch manual intervention would yield negative ROI. These accounts should be routed exclusively into automated digital re-engagement sequences (e.g., self-service FAQ prompts and standard promotional email drips) to preserve customer service capacity for top-tier revenue drivers.

4. **Monetizing and Nurturing Loyal Champions (Priority 3):**
   * With an empirical churn rate of **0.00%** and an average CLTV of **$5,669.27**, this cohort forms the bedrock of predictable recurring cash flow. 
   * **Action:** Shift the communication strategy away from defensive discounts toward advocacy, multi-line family referral bonuses, and annual loyalty rewards.

