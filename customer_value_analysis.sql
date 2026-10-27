-- Customer Value Analysis: SQL queries
-- Database/table names follow the original project setup.

USE fashion_brand;

-- 1. Compare customer segments and discount behavior
SELECT
    Customer_Pyramid,
    `Discount Applied`,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount
FROM final_dataset
GROUP BY Customer_Pyramid, `Discount Applied`
ORDER BY Customer_Pyramid;


-- 2. Quartile-based analysis of previous purchases
-- Preserves the original NTILE(4) approach used in the project.
WITH quartiles AS (
    SELECT
        `Previous Purchases`,
        NTILE(4) OVER (ORDER BY `Previous Purchases`) AS quartile_group
    FROM shopping_trends
)
SELECT
    MIN(CASE WHEN quartile_group = 2 THEN `Previous Purchases` END) AS Q1,
    MIN(CASE WHEN quartile_group = 4 THEN `Previous Purchases` END) AS Q3
FROM quartiles;


-- 3. Geographic customer value and discount usage
SELECT
    Location,
    ROUND(AVG(Customer_Value_Score), 2) AS geography_strength_index,
    ROUND(
        SUM(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS discount_usage_percent
FROM final_dataset
GROUP BY Location
ORDER BY geography_strength_index DESC;
