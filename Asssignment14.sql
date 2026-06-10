CREATE DATABASE DataBank;
USE DataBank;

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50)
);

INSERT INTO regions (region_id, region_name)
VALUES
(1, 'Africa'),
(2, 'America'),
(3, 'Asia'),
(4, 'Europe'),
(5, 'Oceania');

-- A. Customer Nodes Exploration
-- 1. How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;

-- 2. What is the number of nodes per region?
SELECT
    r.region_name,
    COUNT(DISTINCT c.node_id) AS total_nodes
FROM customer_nodes c
JOIN regions r
    ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;

-- 3. How many customers are allocated to each region?
SELECT
    r.region_name,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM customer_nodes c
JOIN regions r
    ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_customers DESC;

-- 4. How many days on average are customers reallocated to a different node?
SELECT
    AVG(DATEDIFF(DAY, start_date, end_date)) AS avg_reallocation_days
FROM customer_nodes
WHERE end_date <> '9999-12-31';

WITH reallocation_days AS (
    SELECT
        r.region_name,
        DATEDIFF(DAY, c.start_date, c.end_date) AS days_diff
    FROM customer_nodes c
    JOIN regions r
        ON c.region_id = r.region_id
    WHERE c.end_date <> '9999-12-31'
)

-- 5. What is the median, 80th and 95th percentile for reallocation days metric for each region?
SELECT DISTINCT
    region_name,

    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY days_diff)
    OVER (PARTITION BY region_name) AS median_days,

    PERCENTILE_CONT(0.8)
    WITHIN GROUP (ORDER BY days_diff)
    OVER (PARTITION BY region_name) AS percentile_80,

    PERCENTILE_CONT(0.95)
    WITHIN GROUP (ORDER BY days_diff)
    OVER (PARTITION BY region_name) AS percentile_95

FROM reallocation_days
ORDER BY region_name;

-- B. Customer Transactions
-- 1. What is the unique count and total amount for each transaction type?
SELECT
    txn_type,
    COUNT(*) AS transaction_count,
    SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type;

-- 2. What is the average total historical deposit counts and amounts for all customers?
WITH customer_deposits AS (
    SELECT
        customer_id,
        COUNT(*) AS deposit_count,
        SUM(txn_amount) AS total_deposit_amount
    FROM customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id
)

SELECT
    AVG(CAST(deposit_count AS FLOAT)) AS avg_deposit_count,
    AVG(CAST(total_deposit_amount AS FLOAT)) AS avg_deposit_amount
FROM customer_deposits;

-- 3. For each month, how many Data Bank customers make more than 1 deposit and either 1
--  purchase or 1 withdrawal in a single month?
WITH monthly_transactions AS (
    SELECT
        customer_id,
        MONTH(txn_date) AS month_num,

        SUM(CASE
                WHEN txn_type = 'deposit' THEN 1
                ELSE 0
            END) AS deposits,

        SUM(CASE
                WHEN txn_type = 'purchase' THEN 1
                ELSE 0
            END) AS purchases,

        SUM(CASE
                WHEN txn_type = 'withdrawal' THEN 1
                ELSE 0
            END) AS withdrawals

    FROM customer_transactions
    GROUP BY
        customer_id,
        MONTH(txn_date)
)

SELECT
    month_num,
    COUNT(customer_id) AS customer_count
FROM monthly_transactions
WHERE deposits > 1
  AND (purchases >= 1 OR withdrawals >= 1)
GROUP BY month_num
ORDER BY month_num;