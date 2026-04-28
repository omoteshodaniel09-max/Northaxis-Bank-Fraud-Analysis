--DELIVERABLE 4--
   WITH MerchantName AS(

    SELECT
        dm.merchant_name,
        COUNT(ft.transaction_key) AS total_transactions,
        SUM(CASE WHEN ft.is_flagged = 1 THEN 1 ELSE 0 END) AS flagged_transactions,
        SUM(ft.amount_usd) AS total_value,
        SUM(CASE WHEN ft.is_flagged = 1 THEN ft.amount_usd ELSE 0 END) AS flagged_value
    FROM fact_transactions ft
    JOIN dim_merchant dm
        ON ft.merchant_key = dm.merchant_key
    GROUP BY dm.merchant_name
)

SELECT
    merchant_name,
    total_transactions,
    flagged_transactions,
    total_value,
    flagged_value,
    flagged_transactions * 1.0 / total_transactions AS flagged_percentage,
    RANK() OVER (
        ORDER BY 
            flagged_transactions * 1.0 / total_transactions DESC,
            flagged_value DESC
    ) AS risk_rank
FROM MerchantName
ORDER BY risk_rank;
GO
