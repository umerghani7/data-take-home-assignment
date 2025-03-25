SELECT
s.id,
business_id,
item_id,
status,
subscription_created_at,
current_term_start,
current_term_end,
cancel_schedule_created_at,
cancelled_at,
channel,
country,
exchange_rate,
currency_code,
billing_period_unit,
CASE
    WHEN billing_period_unit = 'month' THEN unit_price
    WHEN billing_period_unit = 'year' THEN unit_price / 12
    ELSE NULL
END AS monthly_revenue,
CASE
    WHEN billing_period_unit = 'month' THEN unit_price / COALESCE(exchange_rate, 1)
    WHEN billing_period_unit = 'year' THEN (unit_price / 12) / COALESCE(exchange_rate, 1)
    ELSE NULL
END AS monthly_revenue_usd
FROM {{ ref('stg_subscriptions') }} s
LEFT JOIN {{ ref('stg_subscriptions_items') }} i
ON s.item_id = i.id