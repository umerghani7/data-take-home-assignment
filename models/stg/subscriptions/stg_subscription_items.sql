SELECT
CAST(id AS STRING) AS id,
unit_type,
billing_period_unit,
unit_price
FROM {{ source('testing_datalake', 'raw_subscription_items') }}
