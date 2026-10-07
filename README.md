# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Executive Overview
An enterprise-grade subscription analytics repository built on the **IBM Telco Customer Churn** dataset. Utilizing advanced MySQL 8.0 techniques—including multi-tier CTEs, Window Functions (`NTILE`, `DENSE_RANK`), conditional boolean aggregations, and revenue cohort modeling—this project designs an end-to-end customer retention framework.

Rather than treating churn as a single aggregate metric, this analytics suite operates across a four-stage sequential business framework: **Temporal Vulnerability (M1)** ➔ **Financial Exposure & Triage (M2)** ➔ **Competitive Root Cause (M3)** ➔ **Product-Led Ecosystem Moats (M4)**.

---

## 🔄 Strategic Analytical Framework

```mermaid
graph LR
    classDef default fill:#F8FAFC,stroke:#94A3B8,stroke-width:1.5px,color:#0F172A;
    classDef m1 fill:#EFF6FF,stroke:#3B82F6,stroke-width:1.5px,color:#1D4ED8;
    classDef m2 fill:#FFF7ED,stroke:#F97316,stroke-width:1.5px,color:#C2410C;
    classDef m3 fill:#FEF2F2,stroke:#EF4444,stroke-width:1.5px,color:#B91C1C;
    classDef m4 fill:#F0FDF4,stroke:#22C55E,stroke-width:1.5px,color:#15803D;

    M1["01. When: Tenure and Contract Risk"]:::m1
    M2["02. Who: CLTV and Risk Matrix"]:::m2
    M3["03. Why: Root Cause Analysis"]:::m3
    M4["04. How: Value-Added Bundles"]:::m4

    M1 --> M2 --> M3 --> M4
```
---
## 🔄 Strategic Analytical Framework

| 01. When (Vulnerability) | ➔ | 02. Who (Triage) | ➔ | 03. Why (Diagnostics) | ➔ | 04. How (Defense) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [**Tenure & Contract Risk**](./01_customer_tenure_and_contract_churn)<br><sub>0–6 Mo Cliff (55.2% Churn)</sub> | | [**CLTV & Risk Matrix**](./02_cltv_and_risk_scoring_matrix)<br><sub>3×3 Matrix (713 VIPs at Risk)</sub> | | [**Root Cause Analysis**](./03_churn_root_cause_analysis)<br><sub>Competitor (33%) & Support (31%)</sub> | | [**Value-Added Bundles**](./04_value_added_services_retention)<br><sub>Bundling Moat (52% ➔ 5%)</sub> |
