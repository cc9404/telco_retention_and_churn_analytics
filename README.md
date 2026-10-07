# 📊 Telco Customer Retention & Churn Analytics (MySQL)

## 📌 Executive Overview
An enterprise-grade subscription analytics repository built on the **IBM Telco Customer Churn** dataset. Utilizing advanced MySQL 8.0 techniques—including multi-tier CTEs, Window Functions (`NTILE`, `DENSE_RANK`), conditional boolean aggregations, and revenue cohort modeling—this project designs an end-to-end customer retention framework.

Rather than treating churn as a single aggregate metric, this analytics suite operates across a four-stage sequential business framework: **Temporal Vulnerability (M1)** ➔ **Financial Exposure & Triage (M2)** ➔ **Competitive Root Cause (M3)** ➔ **Product-Led Ecosystem Moats (M4)**.

---

## 🔄 Strategic Framework & Analytical Architecture

The diagram below illustrates how each analytical module feeds into the broader customer retention strategy:

```mermaid
flowchart TD
    classDef m1 fill:#E1F5FE,stroke:#0288D1,stroke-width:2px,color:#01579B;
    classDef m2 fill:#FFF3E0,stroke:#F57C00,stroke-width:2px,color:#E65100;
    classDef m3 fill:#FFEBEE,stroke:#D32F2F,stroke-width:2px,color:#B71C1C;
    classDef m4 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px,color:#1B5E20;

    M1["<b>Stage 1: Cohort Lifecycle Dynamics</b><br/><i>Module 01</i><br/>• 0-6 Mo Onboarding Cliff: 55.2% Churn<br/>• $49.7K/mo MRR Attrition"]:::m1
    M2["<b>Stage 2: Value vs Risk Triage</b><br/><i>Module 02</i><br/>• 3x3 CLTV & Risk Scoring Matrix<br/>• Isolates 713 VIPs ($50.8K/mo MRR)"]:::m2
    M3["<b>Stage 3: Root Cause Diagnostics</b><br/><i>Module 03</i><br/>• 33.2% Competitor Threat ($46.6K/mo)<br/>• 31.4% Service & Support Friction"]:::m3
    M4["<b>Stage 4: Product-Led Defense</b><br/><i>Module 04</i><br/>• 6 Value-Added Service Bundles<br/>• 10x Churn Drop (52.2% -> 5.3%)"]:::m4

    M1 -->|Pinpoints Vulnerable Lifecycle Window| M2
    M2 -->|Prioritizes High-Value Accounts to Defend| M3
    M3 -->|Identifies Primary Defection Drivers| M4
    M4 -->|Builds Product Switching Moats & Lowers Churn| M1
