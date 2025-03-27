SELECT
  d.date_day,
  s.id,
  s.business_id,
  s.item_id,
  s.channel,
  IFNULL(s.country, "NA") AS country,
  s.currency_code,
  s.fx_rate_cad_usd,
  s.subscription_created_at,
  s.subscription_plan_start,
  s.subscription_plan_end,
  s.cancel_schedule_created_at,
  s.subscription_cancelled_at
FROM {{ ref('dim_dates') }} AS d
JOIN `testing-project-454720.testing_datalake.stg_subscriptions` AS s
  ON DATE(d.date_day) BETWEEN DATE(s.subscription_created_at)
-- If null means still active, give it a large date
                         AND DATE(IFNULL(s.subscription_cancelled_at, '9999-12-31'))  
-- These dates refer to the start and end dates in our data set. In reality, it should be up until current_date
WHERE d.date_day BETWEEN DATE('2024-01-29') AND DATE('2025-02-17') 
