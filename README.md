# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Project Overview
An end-to-end relational database analytics project leveraging the **IBM Telco Customer Churn** dataset. Using advanced MySQL queries—including Window Functions, Multi-tier Common Table Expressions (CTEs), and Conditional Financial Aggregations—this project transitions away from clickstream web tracking into core subscription unit economics. 

The analysis evaluates customer contract lifecycles, CLTV-to-churn risk segmentation, granular churn root-cause drivers, and value-added service bundle penetration to inform data-driven customer retention and CRM win-back strategies.

---

## 💾 Dataset Overview & Source

* **Data Source:** [IBM Telco Customer Churn Dataset (Kaggle - yeanzc)](https://www.kaggle.com/datasets/yeanzc/telco-customer-churn-ibm-dataset)
* **Raw Data Location:** 📄 [`Telco_customer_churn.csv`](./Telco_customer_churn.csv)
* **Dataset Scale:** 7,043 customer records across 33 demographic, account, and behavioral attributes.

### 🔹 Business Context & Attribute Architecture
This dataset reflects a telecommunications company operating in California, capturing the full customer lifecycle, product usage, satisfaction, and reasons for churn:

| Dimension Category | Core Column Examples | Analytical Utility |
| :--- | :--- | :--- |
| **Account & Financials** | `Contract`, `Tenure Months`, `Monthly Charges`, `Total Charges`, `Payment Method` | Formulate tenure cohort retention curves, calculate customer MRR contribution, and monitor revenue leakage. |
| **Customer Value & Health** | `CLTV`, `Churn Score`, `Churn Value`, `Churn Label` | Build multi-dimensional value-versus-risk segmentation matrices ($3 \times 3$ NTILE matrix) to direct retention spend. |
| **Customer Sentiment & Churn Drivers** | `Churn Category`, `Churn Reason` | Conduct root-cause Pareto diagnostics across competitive pressure, service dissatisfaction, and pricing friction. |
| **Product & Add-on Services** | `Internet Service`, `Online Security`, `Online Backup`, `Device Protection`, `Tech Support`, `Streaming TV`, `Streaming Movies` | Evaluate cross-sell penetration and measure churn suppression lift driven by multi-product bundling. |

---

## 🏗 Repository Structure & Modular Roadmap

```text
telco_retention_and_churn_analytics/
├── README.md                                          <-- Main Project Documentation
│
├── 01_customer_tenure_and_contract_churn/
│   ├── README.md                                      <-- Tenure & Contract Dynamics Analysis
│   ├── customer_tenure_and_contract_churn.sql         <-- SQL Query Script
│   └── final_output.csv                               <-- Aggregated Metric Table
│
├── 02_cltv_and_risk_scoring_matrix/
│   ├── README.md                                      <-- 3x3 CLTV & Risk Scoring Segmentation
│   ├── cltv_and_risk_scoring_matrix.sql               <-- SQL Query Script
│   └── final_output.csv                               <-- High-Value VIP Retention List
│
├── 03_churn_root_cause_analysis/
│   ├── README.md                                      <-- Churn Categorization & Competitive Drivers
│   ├── churn_root_cause_analysis.sql                  <-- SQL Query Script
│   └── final_output.csv                               <-- Root Cause Pareto Table
│
└── 04_value_added_services_retention/
    ├── README.md                                      <-- Cross-Sell Penetration & Retention Lift
    ├── value_added_services_retention.sql             <-- SQL Query Script
    └── final_output.csv                               <-- Feature Bundle Strategy Table
