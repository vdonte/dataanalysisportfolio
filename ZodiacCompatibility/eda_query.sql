USE da_zodiaccompatibilty;

SELECT * FROM dataset_main;


-- Staging data table
DROP TABLE IF EXISTS `dataset_stage`;

CREATE TABLE `dataset_stage` (
    -- `id` int(11) DEFAULT NULL,
    `zx` text DEFAULT NULL,
    `zy` text DEFAULT NULL,
    `compatibility` double DEFAULT NULL,
     `IsCompatible` text DEFAULT NULL
);

INSERT INTO `dataset_stage`
SELECT * FROM `dataset_main`;


SELECT * FROM `dataset_stage`;

DESCRIBE `dataset_stage`;

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE `TABLE_SCHEMA` = 'da_zodiaccompatibilty' AND `table_name` = 'dataset_stage'
ORDER BY ordinal_position;

ALTER TABLE `dataset_stage`
MODIFY COLUMN `IsCompatible` BOOLEAN; 

-- EDA
SELECT * FROM `dataset_stage`;

-- Overview
SELECT DISTINCT(`zx`) AS 'ZodiacSign'
FROM dataset_stage;

SELECT COUNT(DISTINCT(`zx`)) AS 'ZodiacSign'
FROM dataset_stage;

-- CompatibilityScore

WITH CompatinilitySumCount AS (
    SELECT t1.*, t2.`CompatibilityCount`
    FROM (
        SELECT `zx`, 
            CAST(SUM(`compatibility`) AS DECIMAL (10,2)) AS 'CompatibilitySum'
        FROM dataset_stage
        GROUP BY `zx`
    ) t1
    JOIN (
        SELECT `zx`, 
        COUNT(`IsCompatible`) AS 'CompatibilityCount'
        FROM dataset_stage
        WHERE `compatibility` >= 0.5
        GROUP BY `zx`
    ) t2 ON  t1.`zx` = t2.`zx`

    
)
SELECT *,
    (`CompatibilitySum` * `CompatibilityCount`) AS 'CompatibilityScore'
FROM CompatinilitySumCount
ORDER BY `CompatibilityScore` DESC;



