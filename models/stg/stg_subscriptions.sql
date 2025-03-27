WITH ranked_subs AS (
  SELECT
    CAST(id AS STRING) AS id,
    CAST(business_id AS STRING) AS business_id,
    CAST(JSON_VALUE(subscription_plan, '$.item_id') AS STRING) AS item_id,
    status,
    channel,
    country,
    JSON_VALUE(subscription_plan, '$.currency_code') AS currency_code,
    1 / exchange_rate AS fx_rate_cad_usd,
    created_at AS subscription_created_at,
    current_term_start AS subscription_plan_start,
    current_term_end AS subscription_plan_end,
    cancel_schedule_created_at,
    cancelled_at AS subscription_cancelled_at,
    
    -- Partition by id to ensure uniqueness
    ROW_NUMBER() OVER (
      PARTITION BY id
      ORDER BY created_at DESC  -- or current_term_start DESC if preferred
    ) AS row_num
  FROM `testing-project-454720.testing_datalake.raw_subscriptions`
)

SELECT *
FROM ranked_subs
WHERE row_num = 1
