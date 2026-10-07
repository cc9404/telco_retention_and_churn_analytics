# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Executive Overview
An enterprise-grade subscription analytics repository built on the **IBM Telco Customer Churn** dataset. Utilizing advanced MySQL 8.0 techniques—including multi-tier CTEs, Window Functions (`NTILE`, `DENSE_RANK`), conditional boolean aggregations, and revenue cohort modeling—this project designs an end-to-end customer retention framework.

Rather than treating churn as a single aggregate metric, this analytics suite operates across a four-stage sequential business framework: **Temporal Vulnerability (M1)** ➔ **Financial Exposure & Triage (M2)** ➔ **Competitive Root Cause (M3)** ➔ **Product-Led Ecosystem Moats (M4)**.

---

## 🔄 Strategic Analytical Framework

| 01. When (Vulnerability) | ➔ | 02. Who (Triage) | ➔ | 03. Why (Diagnostics) | ➔ | 04. How (Defense) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [**Tenure & Contract Risk**](./01_customer_tenure_and_contract_churn)<br><sub>0–6 Mo Cliff (55.2% Churn)</sub> | | [**CLTV & Risk Matrix**](./02_cltv_and_risk_scoring_matrix)<br><sub>3×3 Matrix (713 VIPs at Risk)</sub> | | [**Root Cause Analysis**](./03_churn_root_cause_analysis)<br><sub>Competitor (33%) & Support (31%)</sub> | | [**Value-Added Bundles**](./04_value_added_services_retention)<br><sub>Bundling Moat (52% ➔ 5%)</sub> |
