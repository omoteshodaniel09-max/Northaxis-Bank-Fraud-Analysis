	--Deliverable 3--
	WITH Customer_avg AS(
	SELECT 
	customer_key,
	transaction_key,
	amount_usd,
	AVG(amount_usd) OVER(PARTITION BY customer_key) AS Average_amount
	FROM fact_transactions
	)
	SELECT 
	customer_key,
    transaction_key,
    amount_usd,
    Average_amount,
    amount_usd - Average_amount AS [amount_above_avg]
	FROM Customer_avg
	WHERE amount_usd > Average_amount * 3
	ORDER BY [amount_above_avg] DESC
