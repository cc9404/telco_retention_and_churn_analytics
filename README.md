# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Executive Overview
An enterprise-grade subscription analytics repository built on the **IBM Telco Customer Churn** dataset. Utilizing advanced MySQL 8.0 techniques—including multi-tier CTEs, Window Functions (`NTILE`, `DENSE_RANK`), conditional boolean aggregations, and revenue cohort modeling—this project designs an end-to-end customer retention framework.

Rather than treating churn as a single aggregate metric, this analytics suite operates across a four-stage sequential business framework: **Temporal Vulnerability (M1)** ➔ **Financial Exposure & Triage (M2)** ➔ **Competitive Root Cause (M3)** ➔ **Product-Led Ecosystem Moats (M4)**.

---
# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Executive Overview
An enterprise-grade subscription analytics repository built on the **IBM Telco Customer Churn** dataset. Utilizing advanced MySQL 8.0 techniques—including multi-tier CTEs, Window Functions (`NTILE`, `DENSE_RANK`), conditional boolean aggregations, and revenue cohort modeling—this project designs an end-to-end customer retention framework.

Rather than treating churn as a single aggregate metric, this analytics suite operates across a four-stage sequential business framework: **Temporal Vulnerability (M1)** ➔ **Financial Exposure & Triage (M2)** ➔ **Competitive Root Cause (M3)** ➔ **Product-Led Ecosystem Moats (M4)**.

---

## 🔄 Strategic Analytical Framework

```mermaid
flowchart LR
    classDef default fill:#F8FAFC,stroke:#94A3B8,stroke-width:1.5px,color:#0F172A,font-size:12px;
    classDef m1 fill:#EFF6FF,stroke:#3B82F6,stroke-width:2px,color:#1D4ED8;
    classDef m2 fill:#FFF7ED,stroke:#F97316,stroke-width:2px,color:#C2410C;
    classDef m3 fill:#FEF2F2,stroke:#EF4444,stroke-width:2px,color:#B91C1C;
    classDef m4 fill:#F0FDF4,stroke:#22C55E,stroke-width:2px,color:#15803D;

    M1["<b>01. When</b><br>Tenure & Contract Risk"]:::m1
    M2["<b>02. Who</b><br>CLTV & Risk Matrix"]:::m2
    M3["<b>03. Why</b><br>Root Cause Analysis"]:::m3
    M4["<b>04. How</b><br>Value-Added Bundles"]:::m4

    M1 --> M2 --> M3 --> M4
    M4 -.->|Retention Loop| M1

    click M1 "./01_customer_tenure_and_contract_churn" "Go to Module 1"
    click M2 "./02_cltv_and_risk_scoring_matrix" "Go to Module 2"
    click M3 "./03_churn_root_cause_analysis" "Go to Module 3"
    click M4 "./04_value_added_services_retention" "Go to Module 4"
