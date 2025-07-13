SELECT *
FROM dataset_clean;

select column_name, data_type, character_maximum_length
from information_schema.columns
where table_name = 'dataset_clean'
ORDER BY ordinal_position;


-- Create a staging dataset
DROP TABLE IF EXISTS dataset_clean_staging1;
CREATE TABLE `dataset_clean_staging1` (
  `state` text DEFAULT NULL,
  `region` text DEFAULT NULL,
  `party` text DEFAULT NULL,
  `votes` int(11) DEFAULT NULL,
  `votes100` double DEFAULT NULL,
  `highest_votes` int(11) DEFAULT NULL,
  `total_votes_counted` int(11) DEFAULT NULL
) ;
INSERT INTO dataset_clean_staging1
SELECT * FROM dataset_clean;


--Overview the dataset
SELECT *
FROM dataset_clean_staging1;

--Check all columns and their data tyoes
select column_name, data_type, character_maximum_length
from information_schema.columns
where table_name = 'dataset_clean_staging1'
ORDER BY ordinal_position;

--Select distinct regions
SELECT DISTINCT region
FROM dataset_clean_staging1;

--Select distinct party
SELECT DISTINCT party
FROM dataset_clean_staging1;

--Select distinct state per region
SELECT DISTINCT state, region
FROM dataset_clean_staging1
--WHERE region = 'North Central'
;


--1. Voting power by region
SELECT DISTINCT region, 
COUNT (state) OVER (PARTITION BY region, party) as `State_Count`,

SUM(total_votes_counted) OVER (PARTITION BY region, party) as `Total_Votes_Sum`,

((SUM(total_votes_counted) OVER (PARTITION BY region, party)) / (SUM(total_votes_counted) OVER (PARTITION BY party)) * 100) as `Votes_Power`
FROM dataset_clean_staging1
ORDER BY 4 DESC
;

--2. Party performance by region
SELECT DISTINCT(region), party,
SUM(votes) OVER (PARTITION BY region, party) as `Party_Votes`,
((SUM(votes) OVER (PARTITION BY region, party)) / (SUM(total_votes_counted) OVER (PARTITION BY region, party)) * 100)  as `Party_Votes_100`

FROM dataset_clean_staging1
GROUP BY state, party
ORDER BY 1,2
;


--3. Voting power by states
SELECT DISTINCT(`state`),
SUM(votes) OVER (PARTITION BY `state`) as `Total_State_Votes`,
((SUM(votes) OVER (PARTITION BY `state`)) / (SUM(votes) OVER ()) * 100)  as `State_Voting_Power`

FROM dataset_clean_staging1
ORDER BY 2 DESC
;

--4. States By Party that won the highest votes
SELECT state, party, votes
FROM dataset_clean_staging1
WHERE votes = highest_votes;


--5. Party performance by states
SELECT state, party,
SUM(votes) as `Party_Votes`,
SUM(votes100) as  `Party_Votes_100`
FROM dataset_clean_staging1
GROUP BY state, party
ORDER BY 1,2
;



