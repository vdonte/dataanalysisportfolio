CREATE DATABASE da_zodiaccompatibilty
    DEFAULT CHARACTER SET = 'utf8mb4';


USE da_zodiaccompatibilty;

DROP TABLE IF EXISTS dataset_main;

CREATE TABLE `dataset_main` (
    -- `id` int(11) DEFAULT NULL,
    `zx` text DEFAULT NULL,
    `zy` text DEFAULT NULL,
    `compatibility` double DEFAULT NULL,
     `IsCompatible` text DEFAULT NULL
);

LOAD DATA INFILE 'dataset_clean.csv'
INTO TABLE `dataset_main`
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT *
FROM dataset_main;