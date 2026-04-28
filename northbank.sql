--DELIVERABLE 1--
SELECT
SUM(amount_usd) AS "Total Value",
AVG(amount_usd) AS "Average Value",
FORMAT(date_key, 'yyyy-MM') AS month,
COUNT(transaction_key) AS [transaction]
FROM fact_transactions
GROUP BY FORMAT(date_key, 'yyyy-MM')
ORDER BY month
GO
SELECT 
channel,
COUNT(transaction_key) AS [Transaction_Count],
SUM(amount_usd) AS [Total_Channel_Value]
FROM fact_transactions
GROUP BY channel
ORDER BY Total_Channel_Value DESC
--transaction type breakdown--
SELECT 
transaction_type,
COUNT(transaction_key) AS [Transaction_Count],
SUM(amount_usd) AS [Transaction_type_Value]
FROM fact_transactions
GROUP BY transaction_type
ORDER BY Transaction_type_Value DESC
--flagged transactions--
SELECT 
is_flagged,
COUNT(transaction_key) AS  [Fraud_detection],
 COUNT(transaction_key) * 100.0 / SUM(COUNT(transaction_key)) OVER() AS [Percentage]
from fact_transactions
GROUP BY is_flagged
--DAILY TRANSACTION TREND--
SELECT
    transaction_date,
    SUM(amount_usd) AS [Total Value],
    COUNT(transaction_key) AS [Transaction_Count],
    AVG(COUNT(transaction_key)) OVER() AS [Daily_Avg],
    CASE 
        WHEN COUNT(transaction_key) > AVG(COUNT(transaction_key)) OVER() 
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS [Volume_Status]
FROM fact_transactions
GROUP BY transaction_date
ORDER BY transaction_date
