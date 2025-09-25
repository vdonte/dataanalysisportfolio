CREATE DATABASE da_VSalesAnalysis
    DEFAULT CHARACTER SET = 'utf8mb4';


USE da_VSalesAnalysis;

DROP TABLE IF EXISTS dataset_main;

CREATE TABLE `dataset_main` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


LOAD DATA INFILE 'dataset_clean.csv'
INTO TABLE `dataset_main`
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM dataset_main;