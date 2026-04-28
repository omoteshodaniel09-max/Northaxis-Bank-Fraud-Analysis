--Deliverable 2--
WITH velocity_anomalies AS (              --VELOCITY ANOMALIES--
    SELECT 
        transaction_key,
        amount_usd,
        account_key,
        transaction_datetime,
        LAG(transaction_datetime) OVER(PARTITION BY account_key ORDER BY transaction_datetime) AS prev_transaction_time
    FROM fact_transactions
)
SELECT
    account_key,
    transaction_key,
    transaction_datetime,
    prev_transaction_time,
    amount_usd,
    DATEDIFF(minute, prev_transaction_time, transaction_datetime) AS minutes_apart
FROM velocity_anomalies
WHERE DATEDIFF(minute, prev_transaction_time, transaction_datetime) <= 10
ORDER BY account_key, transaction_datetime
GO
--transactions that happened at unusual hours--
SELECT
account_key,
    SUM(amount_usd) AS total_amount,
    COUNT(is_off_hours) AS total_hours
	FROM  fact_transactions
    WHERE channel in ('Mobile Banking', 'Web Banking')
	AND transaction_hour >= 1 AND transaction_hour <= 4 
    AND is_off_hours = 1
    GROUP BY account_key
	ORDER BY total_amount DESC
 