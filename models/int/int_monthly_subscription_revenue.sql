WITH Base AS (
  SELECT
  DATE_TRUNC(DATE(s.subscription_created_at), MONTH) AS month,
  s.id,
  s.business_id,
  s.item_id,
  s.channel,
  IFNULL(s.country, 'NA') AS country,
  s.currency_code,
  COALESCE(s.fx_rate_cad_usd, 1) as fx_rate_cad_usd ,
  si.billing_period_unit,
  CASE WHEN billing_period_unit = "year" THEN si.unit_price/12 ELSE si.unit_price END AS monthly_price,

  -- Use 2025-02-17 instead of current_date for static comparison
  TIMESTAMP_DIFF(
    DATE(COALESCE(s.subscription_cancelled_at, DATE '2025-02-17')),
    DATE(s.subscription_created_at),
    MONTH
  ) AS months_between,

  s.subscription_created_at,
  s.subscription_plan_start,
  s.subscription_plan_end,
  s.cancel_schedule_created_at,
  s.subscription_cancelled_at,

FROM {{ ref('stg_subscriptions') }} AS s
LEFT JOIN {{ ref('stg_subscription_items') }}  AS si
  ON s.item_id = CAST(si.id AS STRING)

WHERE DATE(s.subscription_created_at) BETWEEN DATE('2024-01-01') AND DATE('2025-02-01')
)

SELECT 
*,
ROUND(months_between * monthly_price * fx_rate_cad_usd, 0) AS monthly_revenue_usd
FROM Base