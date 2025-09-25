CREATE DATABASE da_23ngelection
    DEFAULT CHARACTER SET = 'utf8mb4';


CREATE TABLE `dataset_main` (
  `state` text DEFAULT NULL,
  `region` text DEFAULT NULL,
  `party` text DEFAULT NULL,
  `votes` int(11) DEFAULT NULL,
  `votes_pct` double DEFAULT NULL,
  `highest_votes` int(11) DEFAULT NULL,
  `total_votes_counted` int(11) DEFAULT NULL
);


LOAD DATA INFILE 'dataset_clean.csv'
INTO TABLE `dataset_main`
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
