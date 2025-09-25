USE da_VSalesAnalysis;

SELECT * FROM dataset_main;


-- Staging data table
DROP TABLE IF EXISTS `dataset_stage`;

CREATE TABLE `dataset_stage` (
  `ordernumber` int(11) DEFAULT NULL,
  `quantityordered` int(11) DEFAULT NULL,
  `priceeach` double DEFAULT NULL,
  `orderlinenumber` int(11) DEFAULT NULL,
  `sales` double DEFAULT NULL,
  `orderdate` text DEFAULT NULL,
  `status` text DEFAULT NULL,
  `qtr_id` int(11) DEFAULT NULL,
  `month_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `productline` text DEFAULT NULL,
  `msrp` int(11) DEFAULT NULL,
  `productcode` text DEFAULT NULL,
  `customername` text DEFAULT NULL,
  `phone` int(11) DEFAULT NULL,
  `addressline1` text DEFAULT NULL,
  `addressline2` text DEFAULT NULL,
  `city` text DEFAULT NULL,
  `state` text DEFAULT NULL,
  `postalcode` text DEFAULT NULL,
  `country` text DEFAULT NULL,
  `territory` text DEFAULT NULL,
  `contactlastname` text DEFAULT NULL,
  `contactfirstname` text DEFAULT NULL,
  `dealsize` text DEFAULT NULL
);

INSERT INTO `dataset_stage`
SELECT * FROM `dataset_main`;


SELECT * FROM `dataset_stage`;


-- Overview
DESCRIBE `dataset_stage`;

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE `TABLE_SCHEMA` = 'da_VSalesAnalysis' AND `table_name` = 'dataset_stage'
ORDER BY ordinal_position;

ALTER TABLE `dataset_stage`
MODIFY COLUMN `orderdate` DATETIME;


-- EDA
--Date Analysis
WITH dateSales AS (
    SELECT `year_id`, `month_id`, `qtr_id`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `year_id`, `month_id`, `qtr_id`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER(PARTITION BY `year_id`) AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `year_id`, `month_id`, `qtr_id`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), dateOrders AS (
    SELECT `year_id`, `month_id`, `qtr_id`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `year_id`, `month_id`, `qtr_id`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER(PARTITION BY `year_id`) AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `year_id`, `month_id`, `qtr_id`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM dateSales t1
JOIN dateOrders t2 ON t1.`year_id` = t2.`year_id` AND t1.`month_id` = t2.`month_id`
ORDER BY `year_id` ASC, `month_id` ASC;



--Customer Analysis
WITH customerSales AS (
    SELECT `customername`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `customername`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER() AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `customername`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), customerOrders AS (
    SELECT `customername`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `customername`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER() AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `customername`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM customerSales t1
JOIN customerOrders t2 ON t1.`customername` = t2.`customername`;



-- Status Analysis
SELECT DISTINCT `status`
FROM dataset_stage ;


-- Univariate Analysis
WITH statusSales AS (
    SELECT `status`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `status`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER() AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `status`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), statusOrders AS (
    SELECT `status`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `status`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER() AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `status`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM statusSales t1
JOIN statusOrders t2 ON t1.`status` = t2.`status`;




-- Sales by Status, Date
WITH statusDateSales AS (
    SELECT `status`, `year_id`, `month_id`, `qtr_id`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `status`, `year_id`, `month_id`, `qtr_id`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER(PARTITION BY `year_id`) AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `status`, `year_id`, `month_id`, `qtr_id`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), statusDateOrders AS (
    SELECT `status`, `year_id`, `month_id`, `qtr_id`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `status`, `year_id`, `month_id`, `qtr_id`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER(PARTITION BY `year_id`) AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `status`, `year_id`, `month_id`, `qtr_id`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM statusDateSales t1
JOIN statusDateOrders t2 ON t1.`status` = t2.`status` AND t1.`year_id` = t2.`year_id` AND t1.`month_id` = t2.`month_id`
ORDER BY `status` ASC, `year_id` ASC, `month_id` ASC;


-- Dealsize Analysis
-- Overview
SELECT DISTINCT `dealsize`
FROM dataset_stage;

-- Univariate Analysis
WITH dealsizeSales AS (
    SELECT `dealsize`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `dealsize`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER() AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `dealsize`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), dealsizeOrders AS (
    SELECT `dealsize`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `dealsize`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER() AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `dealsize`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM dealsizeSales t1
JOIN dealsizeOrders t2 ON t1.`dealsize` = t2.`dealsize`;




-- ProductLine Analysis

-- Overview
SELECT DISTINCT `productline`
FROM dataset_stage;


-- Univariate Analysis
WITH productlineSales AS (
    SELECT `productline`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `productline`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER() AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `productline`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), productlineOrders AS (
    SELECT `productline`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `productline`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER() AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `productline`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM productlineSales t1
JOIN productlineOrders t2 ON t1.`productline` = t2.`productline`;



-- Sales by ProductLine, Date
WITH productlineDateSales AS (
    SELECT `productline`, `year_id`, `month_id`, `qtr_id`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `productline`, `year_id`, `month_id`, `qtr_id`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER(PARTITION BY `year_id`) AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `productline`, `year_id`, `month_id`, `qtr_id`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), productlineDateOrders AS (
    SELECT `productline`, `year_id`, `month_id`, `qtr_id`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `productline`, `year_id`, `month_id`, `qtr_id`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER(PARTITION BY `year_id`) AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `productline`, `year_id`, `month_id`, `qtr_id`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM productlineDateSales t1
JOIN productlineDateOrders t2 ON t1.`productline` = t2.`productline` AND t1.`year_id` = t2.`year_id` AND t1.`month_id` = t2.`month_id`
ORDER BY `productline` ASC, `year_id` ASC, `month_id` ASC;


-- Maximum / Minimum Sales by ProductLine
WITH productlineMax AS (
    SELECT `productline`, `year_id`, `month_id`, `sales_sum_max`
        
    FROM (
        SELECT `productline`, `year_id`, `month_id`, 
            CAST(SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum',
            CAST(MAX(SUM(`sales`)) OVER(PARTITION BY `productline`, `year_id`) AS DECIMAL(10,2)) AS `sales_sum_max`
        FROM dataset_stage
        GROUP BY `productline`, `year_id`, `month_id`
        
    ) t0
    WHERE `sales_sum` = `sales_sum_max`
), productlineMin AS (
    SELECT `productline`, `year_id`, `month_id`, `sales_sum_min`
        
    FROM (
        SELECT `productline`, `year_id`, `month_id`, 
            CAST(SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum',
            CAST(MIN(SUM(`sales`)) OVER(PARTITION BY `productline`, `year_id`) AS DECIMAL(10,2)) AS `sales_sum_min`
        FROM dataset_stage
        GROUP BY `productline`, `year_id`, `month_id`
        
    ) t0
    WHERE `sales_sum` = `sales_sum_min`
)
SELECT t1.`productline`, t1.`year_id`, 
    t1.`month_id` AS 'max_month_id', t1.`sales_sum_max`,
    t2.`month_id` AS 'min_month_id', t2.`sales_sum_min`
FROM productlineMax t1
JOIN productlineMin t2 ON t1.`productline` = t2.`productline` AND t1.`year_id` = t2.`year_id` ;


-- ProductLine Growth analysis
WITH productlineGrowthSales AS (
    SELECT *,
        IFNULL(CAST (`sales_sum` - LAG(`sales_sum`) OVER (ORDER BY `productline`, `year_id`, `month_id`) AS DECIMAL(10,2)), 0) AS 'sales_growth',
        IFNULL(CAST(((`sales_sum` - LAG(`sales_sum`) OVER (ORDER BY `productline`, `year_id`, `month_id`))/LAG(`sales_sum`) OVER (ORDER BY `productline`, `year_id`, `month_id`)) * 100 AS DECIMAL(10,2)), 0) AS 'sales_growth_pct'
        
    FROM (
        SELECT `productline`, `year_id`, `month_id`, 
            CAST(SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum'
        FROM dataset_stage
        GROUP BY `productline`, `year_id`, `month_id`
    ) t1
    ORDER BY `productline`, `year_id`, `month_id`
), productlineGrowthOrder AS (
    SELECT *,
        IFNULL(CAST (`quantityordered_sum` - LAG(`quantityordered_sum`) OVER (ORDER BY `productline`, `year_id`, `month_id`) AS DECIMAL(10,2)), 0) AS 'quantityordered_growth',
        IFNULL(CAST(((`quantityordered_sum` - LAG(`quantityordered_sum`) OVER (ORDER BY `productline`, `year_id`, `month_id`))/LAG(`quantityordered_sum`) OVER (ORDER BY `productline`, `year_id`, `month_id`)) * 100 AS DECIMAL(10,2)), 0) AS 'quantityordered_growth_pct'
        
    FROM (
        SELECT `productline`, `year_id`, `month_id`, 
            CAST(SUM(`quantityordered`) AS INT) AS 'quantityordered_sum'
        FROM dataset_stage
        GROUP BY `productline`, `year_id`, `month_id`
    ) t1
    ORDER BY `productline`, `year_id`, `month_id`
) 
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_growth`, t2.`quantityordered_growth_pct`
FROM productlineGrowthSales t1
JOIN productlineGrowthOrder t2 
    ON t1.`productline` = t2.`productline` 
    AND t1.`year_id` = t2.`year_id` 
    AND t1.`month_id` = t2.`month_id` 
;


-- Country Analysis
WITH countrySales AS (
    SELECT `country`, `sales_sum`, `sales_avg`,
        CAST ((`sales_sum` / `sales_sum_total`) * 100 AS DECIMAL(10,2)) AS 'sales_pct'
        
    FROM (
        SELECT `country`, 
            CAST (SUM(`sales`) AS DECIMAL(10,2)) AS 'sales_sum', 
            CAST (AVG(`sales`) AS DECIMAL(10,2)) AS 'sales_avg',
            SUM(SUM(`sales`)) OVER() AS 'sales_sum_total'
        FROM dataset_stage
        GROUP BY `country`
        ORDER BY `sales_sum` DESC
    ) t0
    ORDER BY `sales_sum` DESC
), countryOrders AS (
    SELECT `country`, `quantityordered_sum`, `quantityordered_avg`,
        CAST ((`quantityordered_sum` / `quantityordered_sum_total`) * 100 AS DECIMAL(10,2)) AS 'quantityordered_pct'
        
    FROM (
        SELECT `country`, 
            CAST (SUM(`quantityordered`) AS INT) AS 'quantityordered_sum', 
            CAST (AVG(`quantityordered`) AS DECIMAL(10,2)) AS 'quantityordered_avg',
            SUM(SUM(`quantityordered`)) OVER() AS 'quantityordered_sum_total'
        FROM dataset_stage
        GROUP BY `country`
        ORDER BY `quantityordered_sum` DESC
    ) t0
    ORDER BY `quantityordered_sum` DESC
)
SELECT t1.*, t2.`quantityordered_sum`, t2.`quantityordered_avg`, t2.`quantityordered_pct`
FROM countrySales t1
JOIN countryOrders t2 ON t1.`country` = t2.`country`
ORDER BY `sales_sum` DESC;






