WITH ranked_businesses AS (
    SELECT
        CAST(id AS STRING) AS id,
        create_date,
        country,
        organizational_type,
        type,
        subtype,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY create_date DESC) AS row_num
    FROM {{ source('testing_datalake', 'raw_business') }}
)

SELECT
    id,
    create_date,
    country,
    organizational_type,
    type,
    subtype
FROM ranked_businesses
WHERE row_num = 1
