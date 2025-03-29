WITH churn_triggers AS (
  SELECT
    DATE(cancel_schedule_created_at) AS churn_trigger_day,
    COUNT(DISTINCT id) AS churn_triggers
  FROM {{ ref('stg_subscriptions') }}
  WHERE cancel_schedule_created_at IS NOT NULL
  GROUP BY 1
),

churns AS (
  SELECT
    DATE(subscription_cancelled_at) AS churn_day,
    COUNT(DISTINCT id) AS churns
  FROM {{ ref('stg_subscriptions') }}
  WHERE subscription_cancelled_at IS NOT NULL
  GROUP BY 1
)

SELECT
  d.date_day,
  COALESCE(ct.churn_triggers, 0) AS churn_triggers,
  COALESCE(c.churns, 0) AS churns
FROM {{ ref('dim_dates') }} AS d
LEFT JOIN churn_triggers ct
  ON d.date_day = ct.churn_trigger_day
LEFT JOIN churns c
  ON d.date_day = c.churn_day
WHERE d.date_day BETWEEN DATE('2024-01-29') AND DATE('2025-02-17')
