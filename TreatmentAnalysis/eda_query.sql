USE healthcare_treament_db;

SELECT * 
FROM dadataset_clean;


CREATE TABLE `dadataset_clean_1` (
  `MyUnknownColumn` int(11) DEFAULT NULL,
  `Name` text DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `Gender` text DEFAULT NULL,
  `Blood_Type` text DEFAULT NULL,
  `Medical_Condition` text DEFAULT NULL,
  `Date_of_Admission` text DEFAULT NULL,
  `Doctor` text DEFAULT NULL,
  `Hospital` text DEFAULT NULL,
  `Insurance_Provider` text DEFAULT NULL,
  `Billing_Amount` double DEFAULT NULL,
  `Room_Number` int(11) DEFAULT NULL,
  `Admission_Type` text DEFAULT NULL,
  `Discharge_Date` text DEFAULT NULL,
  `Medication` text DEFAULT NULL,
  `Test_Results` text DEFAULT NULL,
  `Days_Of_Admission` int(11) DEFAULT NULL,
  `Year_Of_Admission` int(11) DEFAULT NULL,
  `Quarter_Of_Admission` int(11) DEFAULT NULL,
  `Month_Of_Admission` int(11) DEFAULT NULL,
  `Age_Bracket` int(11) DEFAULT NULL
);

INSERT INTO dadataset_clean_1
SELECT * FROM dadataset_clean;

SELECT *
FROM dadataset_clean_1
LIMIT 100;

SELECT COUNT(*)
FROM dadataset_clean_1
LIMIT 100;

ALTER TABLE `dadataset_clean_1`
RENAME TO `dataset_clean_1`;

SELECT *
FROM dataset_clean_1
LIMIT 100;

ALTER TABLE `dataset_clean_1`
CHANGE `MyUnknownColumn` `Idx` INT;

DESCRIBE dataset_clean_1;

ALTER TABLE dataset_clean_1
MODIFY Date_of_Admission DATE;

ALTER TABLE dataset_clean_1
MODIFY Discharge_Date DATE;

--Overview

--Gender
SELECT DISTINCT Gender
FROM dataset_clean_1;

SELECT COUNT(DISTINCT Gender)
FROM dataset_clean_1;


--Blood_Type
SELECT DISTINCT Blood_Type
FROM dataset_clean_1;


--Medical_Condition
SELECT DISTINCT Medical_Condition
FROM dataset_clean_1;


--Doctor
SELECT DISTINCT Doctor
FROM dataset_clean_1;


--Hospital
SELECT DISTINCT Hospital
FROM dataset_clean_1;


--Insurance_Provider
SELECT DISTINCT Insurance_Provider
FROM dataset_clean_1;


--Admission_Type
SELECT DISTINCT Admission_Type
FROM dataset_clean_1;



--Medication
SELECT DISTINCT Medication
FROM dataset_clean_1;


--Test_Results
SELECT DISTINCT Test_Results
FROM dataset_clean_1;


--EDA

--Patient Count Analysis
SELECT `Name`
FROM dataset_clean_1;


-- Treatment_Count by Age
WITH AgeCount AS (
    SELECT *,
        SUM(`Treatment_Count`) OVER () AS `TotalCount`
    FROM (
        SELECT `Age`, COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Age`
        
    ) t
)
SELECT `Age`, `Treatment_Count`,
    CAST((Treatment_Count/TotalCount) * 100 AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
FROM AgeCount
ORDER BY `Age`;


-- Treatment_Count By Age Bracket
WITH Age_Bracket_Count AS (
    SELECT *,
        SUM(`Treatment_Count`) OVER () AS `TotalCount`
    FROM (
        SELECT `Age_Bracket`, 
            MIN(`Age`) AS `Age_Bracket_Min`,
            MAX(`Age`) AS `Age_Bracket_Max`,
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Age_Bracket`
    ) t

    ORDER BY Age_Bracket
)
SELECT `Age_Bracket`,
    `Age_Bracket_Min`,
    `Age_Bracket_Max`,
    `Treatment_Count`,
    CAST((`Treatment_Count` / `TotalCount`) * 100 AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
FROM Age_Bracket_Count;




-- Min And Max Treatment_Count By Age_Bracket
WITH t0 AS (
    WITH Age_Bracket_Count AS (
        SELECT *,
            SUM(`Treatment_Count`) OVER () AS `TotalCount`
        FROM (
            SELECT `Age_Bracket`, 
                MIN(`Age`) AS `Age_Bracket_Min`,
                MAX(`Age`) AS `Age_Bracket_Max`,
                COUNT(`Name`) AS `Treatment_Count`
            FROM dataset_clean_1
            GROUP BY `Age_Bracket`
        ) t

        ORDER BY Age_Bracket
    )
    SELECT `Age_Bracket`,
        `Age_Bracket_Min`,
        `Age_Bracket_Max`,
        `Treatment_Count`,
        CAST((`Treatment_Count` / `TotalCount`) * 100 AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
    FROM Age_Bracket_Count
)
SELECT *
FROM t0
WHERE `Treatment_Count` = (SELECT MIN(`Treatment_Count`) FROM t0) OR  
    `Treatment_Count` = (SELECT MAX(`Treatment_Count`) FROM t0);




-- Treatment_Count By Gender
SELECT `Gender`, `Treatment_Count`,
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100  AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER () AS  `Treatment_Count_Total`
    FROM (
        SELECT `Gender`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Gender`
    ) t
) t0;


-- Treatment_Count By Medical_Condition
SELECT `Medical_Condition`, `Treatment_Count`,
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100  AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER () AS  `Treatment_Count_Total`
    FROM (
        SELECT `Medical_Condition`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Medical_Condition`
    ) t
) t0
ORDER BY `Medical_Condition` ASC;


-- Treatment_Count By Blood_Type
SELECT `Blood_Type`, `Treatment_Count`,
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100  AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER () AS  `Treatment_Count_Total`
    FROM (
        SELECT `Blood_Type`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Blood_Type`
    ) t
) t0
ORDER BY `Blood_Type` ASC;


-- Treatment_Count By Medication
SELECT `Medication`, `Treatment_Count`,
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100  AS DECIMAL(10,2)) AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER () AS  `Treatment_Count_Total`
    FROM (
        SELECT `Medication`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Medication`
    ) t
) t0
ORDER BY `Medication` ASC;


-- Medical_Condition by Medication
SELECT *,
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100 AS DECIMAL(10,2))  AS `Medical_Condition_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER (PARTITION BY `Medical_Condition`) AS `Treatment_Count_Total`
    FROM (
        SELECT `Medical_Condition`, `Medication`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Medical_Condition`, `Medication`
    ) t0
) t1;


-- Medical_Condition by Blood_Type
SELECT *,
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100 AS DECIMAL(10,2))  AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER (PARTITION BY `Medical_Condition`) AS `Treatment_Count_Total`
    FROM (
        SELECT `Medical_Condition`, `Blood_Type`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Medical_Condition`, `Blood_Type`
    ) t0
) t1;


-- Medical_Condition by Billing_Amount
SELECT *,
    CAST((`Billing_Amount_Sum` / `Billing_Amount_Total`) * 100 AS DECIMAL(20,2)) AS `Billing_Amount_Pct`
FROM (
    SELECT *,
        SUM(`Billing_Amount_Sum`) OVER () AS `Billing_Amount_Total`
    FROM (
        SELECT `Medical_Condition`, 
            CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Sum`
        FROM dataset_clean_1
        GROUP BY `Medical_Condition`
    ) t0
)t1
ORDER BY 1 ASC;


-- Medical_Condition by Age
SELECT `Medical_Condition`, `Age`, `Treatment_Count`, 
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100 AS DECIMAL(10,2))  AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER (PARTITION BY `Medical_Condition`) AS `Treatment_Count_Total`
    FROM (
        SELECT `Age`, `Medical_Condition`, 
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Age`, `Medical_Condition`
    ) t0
) t1;




-- Medical_Condition by Age_Bracket
SELECT `Medical_Condition`, `Age_Bracket`, `Age_Bracket_Min`, `Age_Bracket_Max`, `Treatment_Count`, 
    CAST((`Treatment_Count` / `Treatment_Count_Total`) * 100 AS DECIMAL(10,2))  AS `Treatment_Count_Pct`
FROM (
    SELECT *,
        SUM(`Treatment_Count`) OVER (PARTITION BY `Medical_Condition`) AS `Treatment_Count_Total`
    FROM (
        SELECT `Age_Bracket`, `Medical_Condition`, 
			MIN(`Age`) AS `Age_Bracket_Min`,
            MAX(`Age`) AS `Age_Bracket_Max`,
            COUNT(`Name`) AS `Treatment_Count`
        FROM dataset_clean_1
        GROUP BY `Age_Bracket`, `Medical_Condition`
    ) t0
) t1;


-- Billing Amount By Doctor
SELECT `Doctor`, 
    COUNT(`Name`) AS `Treatment_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Total`
FROM dataset_clean_1
GROUP BY `Doctor`;


-- Billing Amount By Hospital
SELECT `Hospital`, 
    COUNT(`Name`) AS `Treatment_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Total`
FROM dataset_clean_1
GROUP BY `Hospital`;



-- Billing Amount By Insurance_Provider
SELECT `Insurance_Provider`, 
    COUNT( `Name`) AS `Treatment_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Total`
FROM dataset_clean_1
GROUP BY `Insurance_Provider`;



-- Billing Amount By Admission_Type
SELECT `Admission_Type`, 
    COUNT( `Name`) AS `Treatment_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Total`
FROM dataset_clean_1
GROUP BY `Admission_Type`;



-- Days_Of_Admission By Medical_Condition
SELECT `Medical_Condition`, 
    MIN(`Days_Of_Admission`) AS `Days_Of_Admission_Min`,
    CAST(AVG(`Days_Of_Admission`) AS DECIMAL(10,2)) AS `Days_Of_Admission_Avg`,
    MAX(`Days_Of_Admission`) AS `Days_Of_Admission_Max`,
    SUM(`Days_Of_Admission`) AS `Days_Of_Admission_Total`
FROM dataset_clean_1
GROUP BY `Medical_Condition`;



-- Treatment_Count by Year_Of_Admission, Quarter_Of_Admission, Month_Of_Admission
SELECT `Year_Of_Admission`, 
    `Quarter_Of_Admission`, `Month_Of_Admission`,
    COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Quarter_Of_Admission`, `Month_Of_Admission`;


-- Treatment_Count by Year_Of_Admission
SELECT `Year_Of_Admission`, COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`;


-- Treatment_Count by Quarter_Of_Admission
SELECT `Year_Of_Admission`, `Quarter_Of_Admission`,
    COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Quarter_Of_Admission`;


-- Treatment_Count by Month_Of_Admission
SELECT `Year_Of_Admission`, 
    `Month_Of_Admission`,
    COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Month_Of_Admission`;



-- Treatment_Count by Year_Of_Admission, Medical_Condition
SELECT `Year_Of_Admission`, `Medical_Condition`,
    COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Medical_Condition`;


-- Treatment_Count by Quarter_Of_Admission, Medical_Condition
SELECT `Year_Of_Admission`, 
    `Medical_Condition`, `Quarter_Of_Admission`,
    COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Medical_Condition`, `Quarter_Of_Admission`;


-- Treatment_Count by Month_Of_Admission, Medical_Condition
SELECT `Year_Of_Admission`, `Medical_Condition`, `Month_Of_Admission`,
    COUNT(`Name`) AS `Treatment_Count`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Medical_Condition`, `Month_Of_Admission`;


-- Billing_Amount by Year_Of_Admission
SELECT `Year_Of_Admission`,
    COUNT(`Name`) AS `Treatement_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Sum`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`;


-- Billing_Amount by Month_Of_Admission
SELECT `Year_Of_Admission`, `Month_Of_Admission`,
    COUNT(`Name`) AS `Treatement_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Sum`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Month_Of_Admission`;



-- Billing_Amount by Quarter_Of_Admission
SELECT `Year_Of_Admission`, `Quarter_Of_Admission`,
    COUNT(`Name`) AS `Treatement_Count`,
    CAST(MIN(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Min`,
    CAST(MAX(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Max`,
    CAST(AVG(`Billing_Amount`) AS DECIMAL(10,2)) AS `Billing_Amount_Avg`,
    CAST(SUM(`Billing_Amount`) AS DECIMAL(20,2)) AS `Billing_Amount_Sum`
FROM dataset_clean_1
GROUP BY `Year_Of_Admission`, `Quarter_Of_Admission`;



