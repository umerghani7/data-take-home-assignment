SELECT
  d.month_start_date AS month

 ,SUM(monthly_revenue_usd) AS monthly_revenue_usd

  ,{{ dbt_utils.pivot(
        column = 'country',
        values=dbt_utils.get_column_values(
          table=ref('int_monthly_subscription_revenue'),
          column='country',
          default=[]
          ),
        prefix='monthly_revenue_usd_',
        then_value='monthly_revenue_usd'
      )
    }}

  ,{{ dbt_utils.pivot(
        column = 'channel',
        values=dbt_utils.get_column_values(
          table=ref('int_monthly_subscription_revenue'),
          column='channel',
          default=[]
          ),
        prefix='monthly_revenue_usd_',
        then_value='monthly_revenue_usd'
      )
    }}


FROM {{ ref('dim_dates') }} as d
LEFT JOIN {{ ref('int_monthly_subscription_revenue') }} AS sub
ON DATE(d.month_start_date) = DATE(sub.month)
WHERE d.month_start_date BETWEEN DATE('2024-01-29') AND DATE('2025-02-17') 
GROUP BY month_start_date

