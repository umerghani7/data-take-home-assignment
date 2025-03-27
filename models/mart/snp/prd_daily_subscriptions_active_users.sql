SELECT
  d.date_day AS date_day

 ,COUNT(id) AS active_subscriptions

 ,{{ dbt_utils.pivot(
       column = 'country',
       values=dbt_utils.get_column_values(
         table=ref('int_daily_active_subscriptions'),
         column='country',
         default=['None']
         ),
       prefix='active_subscriptions_'
     )
   }}

  ,{{ dbt_utils.pivot(
      column = 'channel',
      values=dbt_utils.get_column_values(
        table=ref('int_daily_active_subscriptions'),
        column='channel',
        default=['None']
        ),
      prefix='active_subscriptions_'
    )
  }}

FROM {{ ref('dim_dates') }} as d
LEFT JOIN {{ ref('int_daily_active_subscriptions') }} AS sub
ON DATE(d.date_day) = DATE(sub.date_day)
WHERE d.date_day BETWEEN DATE('2024-01-29') AND DATE('2025-02-17') 
GROUP BY date_day

