SELECT
id,
business_id,
CAST(JSON_VALUE(subscription_plan, '$.item_id') AS INT64) AS item_id,
status,

created_at as subscription_created_at,
current_term_start,
current_term_end,
cancel_schedule_created_at,
cancelled_at,
channel,
country,
exchange_rate,
JSON_VALUE(subscription_plan, '$.currency_code') AS currency_code,
FROM `testing-project-454720.testing_datalake.raw_subscriptions`
