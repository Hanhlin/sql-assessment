

# Question #0 (Already done for you as an example) Select the first 2 rows from the marketing data​
-- ================================================================================================
SELECT TOP 2 * FROM marketing_data;


-- Question #1 Generate a query to get the sum of the clicks of the marketing data​
-- ================================================================================================
SELECT SUM(clicks) AS clicks_sum FROM marketing_data;


-- Question #2 Generate a query to gather the sum of revenue by store_location from the store_revenue table​
-- ================================================================================================
SELECT store_location, SUM(revenue) as revenue_sum
FROM store_revenue
GROUP BY store_location
ORDER BY store_location, revenue_sum;


-- Question #3 Merge these two datasets so we can see impressions, clicks, and revenue together by date and geo. 
-- Please ensure all records from each table are accounted for.​
-- ================================================================================================

-- Extract geo from store_location in store_revenue table, and sum up the revenue by date and geo
SELECT date, RIGHT(RTRIM(store_location), 2) AS geo, sum(revenue) as revenue 
INTO #temp_1
FROM store_revenue
GROUP BY date, store_location
ORDER BY geo, date

SELECT * FROM #temp_1;

-- select all records from marketing_data table which is full joined by #temp_1
-- except for datarows exist in #temp_1 but marketing_data (where condition)
SELECT a.date, a.geo, a.impressions, a.clicks, b.revenue
FROM marketing_data AS a
FULL JOIN #temp_1 AS b
ON a.date = b.date AND a.geo = b.geo
WHERE a.date is NOT NULL

UNION

-- select all records from #temp_1 table which is full joined by marketing_data
SELECT a.date, a.geo, b.impressions, b.clicks, a.revenue
FROM #temp_1 AS a
LEFT JOIN marketing_data AS b
ON a.date = b.date AND a.geo = b.geo
ORDER BY a.geo, a.date


-- Question #4 In your opinion, what is the most efficient store and why?​
-- ================================================================================================

-- SELECT * FROM marketing_data
-- SELECT * FROM store_revenue;

DROP TABLE IF EXISTS #temp_2;
SELECT a.*, b.revenue, (a.clicks / a.impressions) * 100 AS CTR, (b.revenue / a.clicks) as RPC
INTO #temp_2
FROM marketing_data AS a
LEFT JOIN  (
    SELECT date, store_location, sum(revenue) as revenue
    FROM store_revenue
    GROUP BY date, store_location
) AS b
ON a.date = b.date AND a.geo = RIGHT(RTRIM(b.store_location), 2)
ORDER BY a.geo, a.date
SELECT * FROM #temp_2 ORDER BY geo, date ;


DROP TABLE IF EXISTS #temp_3;
SELECT geo, ROUND(AVG(CTR), 2) as CTR_avg, ROUND(AVG(RPC), 2) as RPC_avg
INTO #temp_3
FROM #temp_2
GROUP BY geo
ORDER BY geo
SELECT * FROM #temp_3

-- Final table
SELECT a.geo, a.CTR_avg, a.RPC_avg, b.revenue_sum
FROM #temp_3 AS a
LEFT JOIN (SELECT geo, sum(revenue) AS revenue_sum FROM #temp_1 GROUP BY geo) AS b
ON a.geo = b.geo
ORDER BY geo

/* 
    In my opinion, the store in "CA" is the most efficient.
    First, I take the store in MN out of the consideration because it does not have the revenue data, which means it cannot be compared with others.
    And, based on the average CTR, average RPC, and total revenue, the table shows that the store in CA is the most efficient
*/


-- Question #5 (Challenge) Generate a query to rank in order the top 10 revenue producing states​
-- ================================================================================================
SELECT TOP 10 store_location, SUM(revenue) AS revenue_sum
FROM store_revenue
GROUP BY store_location
ORDER BY revenue_sum DESC

-- SELECT TOP 10 brand_id, store_location, SUM(revenue) AS revenue_sum
-- FROM store_revenue
-- GROUP BY brand_id, store_location
-- ORDER BY revenue_sum DESC


