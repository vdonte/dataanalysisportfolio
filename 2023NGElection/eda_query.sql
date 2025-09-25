USE da_23ngelection;

SELECT * 
FROM `dataset_main`;


-- Staging data table
DROP TABLE IF EXISTS `dataset_stage`;

CREATE TABLE `dataset_stage` (
  `state` text DEFAULT NULL,
  `region` text DEFAULT NULL,
  `party` text DEFAULT NULL,
  `votes` int(11) DEFAULT NULL,
  `votes_pct` double DEFAULT NULL,
  `highest_votes` int(11) DEFAULT NULL,
  `total_votes_counted` int(11) DEFAULT NULL
);

INSERT INTO `dataset_stage`
SELECT * FROM `dataset_main`;


SELECT * FROM `dataset_stage`;

DESCRIBE `dataset_stage`;

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE `TABLE_SCHEMA` = 'da_23ngelection' AND `table_name` = 'dataset_stage'
ORDER BY ordinal_position;





-- Overview

--regions
SELECT DISTINCT `region`
FROM `dataset_stage`;

--parties
SELECT DISTINCT `party`
FROM `dataset_stage`;


-- states
SELECT `state`, `region`
FROM `dataset_stage`
GROUP BY `state`;

-- Total Sum of votes
SELECT SUM(`votes`)
FROM `dataset_stage`;


-- 1. Voting Performance By Region
WITH regionvotes AS (
    SELECT *,
        SUM(`votes`) OVER() AS `votes_total`
    FROM (
        SELECT t1.*, `state_count`
        FROM (
            SELECT `region`, SUM(`votes`) AS `votes`
            FROM `dataset_stage`
            GROUP BY `region`
        ) t1
        JOIN (
            SELECT `region`, COUNT(DISTINCT(`state`)) AS `state_count`
            FROM `dataset_stage`
            GROUP BY `region`
        ) t2 ON t1.`region` = t2.`region`
    ) t0
)
SELECT `region`, `votes`,
    CAST((`votes` / `votes_total`) * 100 AS DECIMAL(10,2)) AS `votes_pct`,
    `state_count`
FROM `regionvotes`
ORDER BY `votes_pct` DESC;




-- 2. Voting Performance By Region
SELECT `region`, `party`, `votes`,
    CAST((`votes` / `total_votes_counted`) * 100 AS DECIMAL(10,2)) AS `votes_pct`
FROM (
    SELECT *, 
        SUM(`votes`) OVER (PARTITION BY `region`) AS `total_votes_counted`
    FROM (
        SELECT `region`, `party`, SUM(`votes`) AS `votes`
        FROM `dataset_stage`
        GROUP BY `region`, `party`
    ) t1
) t0
ORDER BY `region`, `votes_pct` DESC;


-- 3. Voting Performance by States
WITH statevotes AS (
    SELECT *,
        SUM(`votes`) OVER() AS `votes_total`
    FROM (
        SELECT `state`, SUM(`votes`) AS `votes`
        FROM `dataset_stage`
        GROUP BY `state`
    ) t1
)
SELECT *,
    CAST((`votes` / `votes_total`) * 100 AS DECIMAL (10,2)) AS `votes_pct`
FROM `statevotes`
ORDER BY `votes_pct` DESC;

--4. Party performance by states
WITH statepartyhighest AS (
    SELECT *
    FROM `dataset_stage`
    WHERE `highest_votes` = `votes`
    ORDER BY `votes_pct` DESC
)
SELECT t1.*, t2.`state`, t2.`votes_pct`
FROM (
    SELECT `party`, SUM(`votes`) AS `total_votes_won`,
        MAX(`votes`) AS `maximum_votes_won`,
        COUNT(`state`) AS `total_states_won`
    FROM statepartyhighest
    GROUP BY `party`
) t1
JOIN (
    SELECT `party`, `state`, `votes_pct`
    FROM (
        SELECT `party`, `state`, `votes`, `votes_pct`,
            MAX(`votes`) OVER (PARTITION BY `party`) AS `votes_max`
        FROM statepartyhighest
    )t21
    WHERE `votes_max` = `votes`
) t2 ON t1.`party` = t2.`party`

--5. Voting Performance Nationaly
WITH voting_performance AS (
    SELECT *, 
        SUM(`votes`) OVER () AS `votes_total`
    FROM (
        SELECT `party`, SUM(`votes`) AS `votes`
        FROM `dataset_stage`
        GROUP BY `party`
    ) t1
), voting_performance_pct AS (
    SELECT `party`, `votes`,
        CAST((`votes` / `votes_total`) * 100 AS DECIMAL (10,2)) AS `votes_pct`
    FROM voting_performance
    ORDER BY `votes_pct` DESC
)
SELECT `voting_performance`, `party`, `votes`, `votes_pct`
FROM (
    SELECT *,
        RANK() OVER(ORDER BY `votes_pct` DESC) AS `voting_performance`
    FROM voting_performance_pct
) t2



-- 6. Party Perfomance Nationaly
SELECT *, 
    CAST((`votes` / `total_votes_counted`) * 100 AS DECIMAL (10,2)) AS `votes_pct`
FROM (
    SELECT `state`, `party`, SUM(`votes`) AS `votes`,
        SUM(`votes`) OVER (PARTITION BY `state`) AS `total_votes_counted`
    FROM `dataset_stage`
    GROUP BY `state`, `party`
) t1
ORDER BY `state` ASC, `votes_pct` DESC