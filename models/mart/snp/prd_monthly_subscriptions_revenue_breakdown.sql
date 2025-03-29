SELECT
month,
ROUND((monthly_revenue_usd_US/monthly_revenue_usd) * 100,2) AS monthly_revenue_usd_US_ratio,
ROUND((monthly_revenue_usd_CA/monthly_revenue_usd) * 100,2) AS monthly_revenue_usd_CA_ratio,
ROUND((monthly_revenue_usd_NA/monthly_revenue_usd) * 100, 2) AS monthly_revenue_usd_NA_ratio,
ROUND((monthly_revenue_usd_web/monthly_revenue_usd) * 100, 2) AS monthly_revenue_usd_web_ratio,
ROUND((monthly_revenue_usd_app_store/monthly_revenue_usd) * 100, 2) AS monthly_revenue_usd_app_store_ratio,
ROUND((monthly_revenue_usd_play_store/monthly_revenue_usd) * 100, 2) AS monthly_revenue_usd_play_store_ratio
FROM
{{ ref('prd_monthly_subscriptions_revenue') }} 