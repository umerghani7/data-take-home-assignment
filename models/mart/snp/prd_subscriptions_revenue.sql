SELECT
  dates.date_day AS date_day

 ,COUNT(id) AS subscriptions

 ,{{ dbt_utils.pivot(
       column = 'status',
       values=dbt_utils.get_column_values(
         table=ref('fct_subscriptions'),
         column='status',
         default=[]
         ),
       prefix='subscriptions_'
     )
   }}

 ,{{ dbt_utils.pivot(
       column = 'channel',
       values=dbt_utils.get_column_values(
         table=ref('fct_subscriptions'),
         column='channel',
         default=[]
         ),
       prefix='subscriptions_'
     )
   }}


FROM {{ ref('dim_dates') }} as dates
LEFT JOIN {{ ref('fct_subscriptions') }} AS sub
ON DATE(dates.date_day) = DATE(sub.subscription_created_at)
WHERE subscription_created_at IS NOT NULL
GROUP BY date_day
