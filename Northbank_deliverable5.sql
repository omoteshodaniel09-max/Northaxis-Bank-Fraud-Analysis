--DELIVERABLE 5--
--Fraud Risk Scoring model--
WITH BaseAGG AS(
SELECT 
merchant_key,
COUNT(*) AS total_transactions,        
SUM(amount_usd) AS total_amount,
AVG(amount_usd) AS average_amount,
SUM(CASE WHEN is_flagged = 1 THEN 1 ELSE 0 END) AS flagged_transactions,
SUM(CASE WHEN is_flagged = 1 THEN amount_usd ELSE 0 END) AS flagged_amount
FROM fact_transactions
GROUP BY merchant_key
),
Features AS (
    SELECT *,
         flagged_transactions * 1.0 / NULLIF(total_transactions, 0) AS flagged_rate,
         flagged_amount * 1.0 / NULLIF(total_amount, 0) AS flagged_amount_rate
         FROM BaseAGG
), 
Scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY flagged_rate DESC) AS risk_flag_rate_score,
        NTILE(5) OVER (ORDER BY flagged_amount_rate DESC) AS risk_value_score,
        NTILE(5) OVER (ORDER BY total_amount DESC) AS exposure_score
    FROM Features
), 
FinalScore AS (
    SELECT *,
        (0.4 * risk_flag_rate_score +
         0.4 * risk_value_score +
         0.2 * exposure_score) AS composite_risk_score
    FROM Scored
)
SELECT TOP 10
   merchant_key,
    total_transactions,
    total_amount,
    flagged_transactions,
    flagged_rate,
    composite_risk_score,
    CASE 
        WHEN composite_risk_score >= 4 THEN 'HIGH RISK'
        WHEN composite_risk_score >= 3 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_category
FROM FinalScore
ORDER BY composite_risk_score DESC;
