# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Executive Overview
An enterprise-grade subscription analytics repository built on the **IBM Telco Customer Churn** dataset. Utilizing advanced MySQL 8.0 techniques—including multi-tier CTEs, Window Functions (`NTILE`, `DENSE_RANK`), conditional boolean aggregations, and revenue cohort modeling—this project designs an end-to-end customer retention framework.

Rather than treating churn as a single aggregate metric, this analytics suite operates across a four-stage sequential business framework: **Temporal Vulnerability (M1)** ➔ **Financial Exposure & Triage (M2)** ➔ **Competitive Root Cause (M3)** ➔ **Product-Led Ecosystem Moats (M4)**.

---

## 🔄 Strategic Analytical Framework

| 01. When (Vulnerability) | ➔ | 02. Who (Triage) | ➔ | 03. Why (Diagnostics) | ➔ | 04. How (Defense) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [**Tenure & Contract Risk**](./01_customer_tenure_and_contract_churn)<br><sub>0–6 Mo Cliff (55.2% Churn)</sub> | | [**CLTV & Risk Matrix**](./02_cltv_and_risk_scoring_matrix)<br><sub>3×3 Matrix (713 VIPs at Risk)</sub> | | [**Root Cause Analysis**](./03_churn_root_cause_analysis)<br><sub>Competitor (33%) & Support (31%)</sub> | | [**Value-Added Bundles**](./04_value_added_services_retention)<br><sub>Bundling Moat (52% ➔ 5%)</sub> |

---

## 🗂 Modular Navigation & Strategic Synergy

Click directly into each module's dedicated folder to explore the executable SQL queries, raw benchmark data, and business strategies:

| Module & Direct Link | Core Strategic Question | Primary SQL Methodologies | Key Deliverables & Artifacts |
| :--- | :--- | :--- | :--- |
| 🔗 [**Module 01: Customer Tenure & Contract Dynamics**](./01_customer_tenure_and_contract_churn) | **WHEN do customers churn?**<br>Identifies the initial onboarding "danger zone" and compares Month-to-Month volatility against annual contracts. | `CASE WHEN` cohorting, conditional revenue sums, multi-level `GROUP BY`. | 📄 [`SQL Script`](./01_customer_tenure_and_contract_churn/customer_tenure_and_contract_churn.sql)<br>📊 [`final_output.csv`](./01_customer_tenure_and_contract_churn/final_output.csv) |
| 🔗 [**Module 02: CLTV & Risk Scoring Matrix**](./02_cltv_and_risk_scoring_matrix) | **WHO is worth saving?**<br>Maps customers across a $3 \times 3$ value-versus-risk matrix to direct high-touch retention budgets toward VIPs. | `NTILE(3) OVER()`, Multi-tier CTEs, percentile cross-tabulation. | 📄 [`SQL Script`](./02_cltv_and_risk_scoring_matrix/cltv_and_risk_scoring_matrix.sql)<br>📊 [`final_output.csv`](./02_cltv_and_risk_scoring_matrix/final_output.csv) |
| 🔗 [**Module 03: Churn Root Cause Analysis**](./03_churn_root_cause_analysis) | **WHY do subscribers leave?**<br>Ranks specific defection reasons and groups them into 5 strategic macro pillars (competitor offers, service attitude, price). | `DENSE_RANK() OVER()`, `SUM() OVER()`, substring pattern mapping. | 📄 [`SQL Script`](./03_churn_root_cause_analysis/churn_root_cause_analysis.sql)<br>📊 [`final_output.csv`](./03_churn_root_cause_analysis/final_output.csv) |
| 🔗 [**Module 04: Value-Added Services & Retention**](./04_value_added_services_retention) | **HOW do we structurally defend them?**<br>Evaluates how bundling 6 digital add-ons (Security, Tech Support) builds switching costs and drives ARPU expansion. | Boolean add-on scoring, bundle tiering, penetration tracking. | 📄 [`SQL Script`](./04_value_added_services_retention/value_added_services_retention.sql)<br>📊 [`final_output.csv`](./04_value_added_services_retention/final_output.csv) |

---

## 💾 Dataset Overview & Source

* **Data Source:** [IBM Telco Customer Churn Dataset (Kaggle - yeanzc)](https://www.kaggle.com/datasets/yeanzc/telco-customer-churn-ibm-dataset)
* **Raw File:** 📄 [`Telco_customer_churn.csv`](./Telco_customer_churn.csv)
* **Scale:** 7,043 customer accounts across 33 demographic, billing, and subscription variables.

### 🔹 Dimension Categorization & Functional Use

| Dimension Category | Core Column Examples | Analytical Role Across Modules |
| :--- | :--- | :--- |
| **Contract & Billing** | `Contract`, `Tenure Months`, `Monthly Charges`, `Payment Method` | Powers **Module 01** lifecycle duration tracking and identifies MRR revenue leakage windows. |
| **Account Health & Value** | `CLTV`, `Churn Score`, `Churn Value` | Powers **Module 02** matrix segmentation, isolating VIP accounts from low-value churn risks. |
| **Defection Drivers** | `Churn Reason`, `Churn Label` | Powers **Module 03** root-cause diagnostics across competitive pricing and customer service quality. |
| **Add-On Ecosystem** | `Online Security`, `Tech Support`, `Device Protection`, `Streaming TV` | Powers **Module 04** bundle saturation analysis to prove ecosystem-level churn suppression. |

---

## 💡 Executive Summary of Cross-Module Findings

1. **The 0–6 Month Cliff (M1):** 
   Month-to-month contracts experience a **55.20% churn rate** during the first 180 days, leaking **$49,681.30/month** in recurring revenue. This identifies the precise operational window where onboarding interventions must occur.
2. **Protecting Core VIPs (M2):** 
   Rather than discounting all churn risks, Module 2 identifies **713 high-CLTV subscribers in the high-risk tercile** ($50,848.85 MRR at risk). These VIPs justify dedicated, high-touch account management.
3. **Primary Threat Vectors (M3):** 
   Over **64% of churn** is concentrated in two areas: **Competitor Threat (33.23%)** (faster download speeds, more data) and **Customer Service & Support Friction (31.40%)** (specifically support person attitude).
4. **The Product Ecosystem Moat (M4):** 
   Single-play internet users churn at **52.24%**, but expanding subscribers to 4+ add-ons slashes churn to **under 15%** (bottoming out at **5.28%** for full 6-feature users), while increasing monthly ARPU from $58.59 to $99.37.
