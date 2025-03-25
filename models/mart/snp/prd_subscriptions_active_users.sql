WITH total_active_subscriptions AS (
  SELECT
    dd.date_day,
    COUNT(DISTINCT fs.id) AS total_active_subscriptions
  FROM {{ ref('fct_subscriptions') }} fs
  JOIN {{ ref('dim_dates') }} dd
    ON dd.date_day >= DATE(fs.current_term_start)
    AND dd.date_day < DATE(fs.current_term_end)
  WHERE fs.status = 'active'
  GROUP BY dd.date_day
),

daily_active_subscriptions AS (
  SELECT
    dd.date_day,
    COUNT(*) AS daily_active_subscriptions
  FROM {{ ref('fct_subscriptions') }} sub
  JOIN {{ ref('dim_dates') }} dd
    ON DATE(sub.subscription_created_at) = DATE(dd.date_day)
    GROUP BY dd.date_day
),

churned_users AS (
    SELECT
    dd.date_day,
    COUNT(*) AS churned_users
    FROM {{ ref('fct_subscriptions') }} sub
    JOIN {{ ref('dim_dates') }} dd
    ON DATE(sub.cancelled_at) = DATE(dd.date_day)
    GROUP BY dd.date_day
),

churned_triggered AS (
    SELECT
    dd.date_day,
    COUNT(*) AS churn_triggered
    FROM {{ ref('fct_subscriptions') }} sub
    JOIN {{ ref('dim_dates') }} dd
    ON DATE(sub.cancel_schedule_created_at) = DATE(dd.date_day)
    GROUP BY dd.date_day
)

SELECT
dd.date_day,
COALESCE(s.total_active_subscriptions, 0) AS total_active_subscriptions,
COALESCE(a.daily_active_subscriptions, 0) AS daily_active_subscriptions,
COALESCE(churn_triggered, 0) AS churn_triggered,
COALESCE(churned_users, 0) AS churned_users
FROM {{ ref('dim_dates') }} dd
LEFT JOIN total_active_subscriptions s USING (date_day)
LEFT JOIN daily_active_subscriptions a USING (date_day)
LEFT JOIN churned_triggered t USING (date_day)
LEFT JOIN churned_users u USING (date_day)
WHERE date_day BETWEEN DATE("2024-01-29") AND DATE("2024-06-03")