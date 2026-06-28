# AML_Surveillance_Sql_Project
Enterprise-level AML transaction surveillance and data analytics project using PostgreSQL.

## Project Overview
This repository contains an enterprise-level data-driven Anti-Money Laundering (AML) transaction monitoring and alert-generation infrastructure designed for retail banking environments. Leveraging a Computer Science and Engineering background, this framework screens high-volume transaction logs to isolate financial crime typologies, velocity anomalies, and data leakage before funds exit the banking ecosystem.

## 1. Database Architecture & Setup
The project utilizes a 3-tier normalized relational database architecture designed to ensure absolute data lineage, handle integrity constraints, and eliminate redundancy:
- **`occupation_master`**:- An identity-driven master table separating customer demographic roles (e.g., Student, HNI Businessman, Politically Exposed Persons) using `AUTO_INCREMENT` keys to automate entity indexing.
- **`customers`**:- The core profile table mapping unique entities, age metrics, cities, risk classifications (Low, Medium, High), and active PEP statuses linked via relational foreign keys.
- **`transactions`**:- A high-velocity transaction ledger logging digital transaction types, amounts, precise timestamps, transaction channels (UPI, IMPS, RTGS, ATM), and operational statuses (`SUCCESS` filters).

## 2. Core AML Queries Resolved
To systematically investigate the simulated ledger, optimized multi-table `INNER JOIN` queries incorporating conditional data filters, aggregate functions (`COUNT`, `SUM`), and structural `GROUP BY / HAVING` constraints were executed to resolve 5 investigative scenarios:

### Query 1: Structuring / Smurfing Anomaly Detection
Designed a multi-join scenario to catch low-risk profiles intentionally bypassing the regulatory Currency Transaction Report (CTR) limits by structuring multiple successful deposits between ₹9,000 and ₹9,999 within a tight 24-hour velocity window.
- **Technical Logic**: Filtered `t.amount BETWEEN 9000 AND 9999` and aggregated counts using `HAVING COUNT(t.transaction_id) >= 3`.

### Query 2: Full Transaction Ledger Audit
Triggered a comprehensive chronological forensic audit for the flagged target entity (Account ID 101) to trace the end-to-end timeline of both successful and declined transactions.

### Query 3: Pass-Through / Net Balance Check
Constructed an analytics query using conditional aggregation (`SUM(CASE WHEN...)`) to compare total incoming funds versus total outgoing volumes within the same accounting day to identify pipeline routing characteristics.

### Query 4: Channel-Wise Volumetric Breakdown
Developed a transactional data query grouping the suspicious entity's velocity by payment channels (UPI, IMPS, RTGS) to extract data for downstream dashboard visualization.

### Query 5: Velocity Anomaly & High-Risk PEP Surveillance
Automated cross-table intelligence logic to screen remaining customer databases for deep-rooted compliance red flags:
- Isolate immediate pass-through pipeline velocity among unemployed youth profiles (funds withdrawn within 5 minutes of deposit).
- Monitor large-volume fund movements exceeding ₹2,00,000 on active Politically Exposed Persons (PEPs) requiring immediate Enhanced Due Diligence (EDD).

## 🎯 3. Final Query Output Results
The outputs from the analytical queries were successfully extracted and compiled into 5 distinct operational `.csv` dataset reports now stored in this repository:
1. **`Structuring_Alert.csv`**: Successfully isolated Account ID 101 (Ramesh Sharma, Student, Low Risk) for triggering 4 rapid structured UPI deposits totaling ₹38,100.
2. **`Full_Transaction_Audit.csv`**: Mapped the complete 24-hour transactional ledger for the primary target profile.
3. **`Velocity Anomaly.csv`**: Confirmed a 100% pipeline velocity flow with zero remaining balance, proving the target account acted as a data pass-through.
4. **`Channel_Wise_Volume.csv`**: Isolated UPI as the primary attack vector for the structuring attempt, capturing 4 instances totaling ₹38,100.
5. **`High-Risk_PEP_Alert.csv` & `Customer_Velocity_Anomaly.csv`**: Successfully flagged Account 104 (Vijay Singh, Unemployed) for a 5-minute velocity pass-through of ₹45,000 and Account 105 (Vikram Adani, PEP) for an unverified ₹4,50,000 RTGS exposure.

