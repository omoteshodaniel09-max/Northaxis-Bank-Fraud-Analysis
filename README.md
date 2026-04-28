# Transaction Fraud Detection & Risk Intelligence Report

## Problem
Investigating transaction patterns, surfacing anomalies, and profiling high-risk accounts within the Northaxis Bank database.

## Tool Used
SQL Server Management Studio 22

## Database Schema
Star Schema consisting of 6 tables:
- **fact_transactions** — central fact table
- **dim_merchant** — merchant details
- **dim_customer** — customer details
- **dim_account** — account details
- **dim_date** — date details
- **dim_location** — location details

## Deliverable 1 — Transaction Overview & Baseline KPIs
**Purpose:** Establish what normal activity looks like before checking for anomalies.

**Key Queries:** Monthly trends, channel performance, transaction type breakdown, fraud percentage, daily volume trends.

**Results:**
- July 2024 recorded the highest total transaction value at approximately $60.2M with 24,521 transactions
- Mobile Banking was the dominant channel at $145.9M across 77,973 transactions
- Wire Transfer was the highest grossing transaction type at approximately $244.1M
- 89.9% of transactions were legitimate while 10.1% were flagged as potentially fraudulent
- The overall daily transaction average was 712 transactions per day

## Deliverable 2 — Velocity Anomalies & Off-Hours Activity
**Purpose:** Detect suspicious rapid transactions and unusual late-night activity.

**Key Queries:** LAG window function for velocity anomalies, off-hours filter for 1AM-4AM digital transactions.

**Results:**
- Account 4 recorded the highest velocity anomaly activity with multiple transactions occurring seconds apart
- Account 178 recorded the highest off-hours activity with a total value of $910,148 across 89 transactions

## Deliverable 3 — Abnormal Customer Spending
**Purpose:** Identify customers whose transactions significantly deviate from their normal spending pattern.

**Key Queries:** AVG window function partitioned by customer, filtered for transactions exceeding 3x the customer average.

**Results:**
- Customer 281 recorded the highest anomalous transaction at approximately $49,477 nearly six times their average spending of $8,254 with an excess of $41,223 above their normal pattern

## Deliverable 4 — Merchant Fraud Risk Ranking
**Purpose:** Rank merchants by fraud risk based on flagged transaction percentage and flagged value.

**Key Queries:** CTE with JOIN between fact_transactions and dim_merchant, RANK window function ordered by flagged percentage.

**Results:**
- 8 merchants including SwiftFunds Inc and ClearPath Remit had a 100% flagged transaction rate
- SwiftFunds Inc ranked first with 1,733 flagged transactions totalling approximately $28.2M
- From rank 9 onwards flagged rates dropped to approximately 3-4%

## Deliverable 5 — Fraud Risk Scoring Model
**Purpose:** Build a composite risk scoring model to classify merchants as High, Medium or Low Risk.

**Key Queries:** Multiple CTEs using NTILE(5) across three dimensions flagged rate, flagged amount rate and total exposure combined into a weighted composite score.

**Results:**
- 14 merchants classified as High Risk, 14 as Medium Risk, 17 as Low Risk
- SpiceGarden and QuickBite scored the highest composite risk score of 5.0
- Note: High-value low-volume merchants like SwiftFunds Inc scored 1.0 despite 100% flagged rates a known limitation of volume-based NTILE scoring

## Recommendations
1. First-time offending accounts should face temporary suspension and monitoring, while repeat offenders should be permanently blocked
2. Multi-factor authentication should be enforced for all transactions conducted between 1AM and 4AM
3. Transaction limits should be set for accounts making multiple transactions within 10 minutes
4. Merchants with consistently high flagged rates should be placed under strict review and subjected to transaction caps
