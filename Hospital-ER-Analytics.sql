#-- PROJECT: Hospital Emergency Room (ER) Analytics & Performance Tuning
#-- DATASET: Real-world ER Operational Data
#____________________________________________________________________________#

CREATE DATABASE HospitalER_DB;

SHOW databases;

USE HospitalER_DB;
 
show tables;

select * from hospital_er;

ALTER TABLE hospital_er
CHANGE COLUMN `ï»¿Patient Id` `Patient_Id` VARCHAR(50);

select * from hospital_er;
#____________________________________________________________________________#

-- # Q 1 : How do we inspect the first 10 rows of the dataset to verify the successful column name change?
SELECT * FROM hospital_er 
LIMIT 10;

-- # Q 2 : What is the exact total number of patient records successfully imported into the table?
SELECT COUNT(*) AS Total_ER_Visits 
FROM hospital_er;

-- Q 3: What is the distribution of patients by gender?
SELECT `Patient Gender`, COUNT(*) AS Total_Patients
FROM hospital_er
GROUP BY `Patient Gender`
ORDER BY Total_Patients DESC;

-- Q 4: What is the average, minimum, and maximum age of patients visiting the ER?
SELECT 
    round(AVG(`Patient Age`),0) AS Average_Age, 
    MIN(`Patient Age`) AS Minimum_Age, 
    MAX(`Patient Age`) AS Maximum_Age
FROM hospital_er;

-- Q 5: How many patients visited the ER from each patient race?
SELECT
 `Patient Race`, COUNT(*) AS Patient_Count
FROM hospital_er
GROUP BY `Patient Race`
ORDER BY Patient_Count DESC;

-- Q 5: How many unique Patient Races are recorded in the ER?
SELECT 
COUNT(DISTINCT `Patient Race`) AS Unique_Race_Count
FROM hospital_er;

-- Q 7: How many patients were successfully admitted to the hospital (where Admission Flag is True)?
SELECT 
`Patient Admission Flag`, COUNT(*) AS Total_Count
FROM hospital_er
GROUP BY `Patient Admission Flag`;

-- # Q 8: What are the different unique types of Department Referrals available in the dataset?
SELECT
DISTINCT `Department Referral` 
FROM hospital_er 
WHERE `Department Referral` IS NOT NULL AND `Department Referral` != 'None';

-- # Q 9: How many records have missing (NULL) values for the Patient Satisfaction Score?
SELECT 
COUNT(*) AS Missing_Satisfaction_Scores 
FROM hospital_er 
WHERE `Patient Satisfaction Score` IS NULL;

-- # Q 10: List the top 5 oldest patients who visited the Emergency Room.
SELECT 
Patient_Id, `Patient First Inital`, `Patient Last Name`, `Patient Age`
FROM hospital_er
ORDER BY `Patient Age` DESC
LIMIT 5;

-- # Q 11: List the top 5 youngest patients who visited the Emergency Room.
SELECT 
Patient_Id, `Patient First Inital`, `Patient Last Name`, `Patient Age`
FROM hospital_er
ORDER BY `Patient Age` ASC
LIMIT 5;

-- # Q 11: What is the average patient wait time for each department referral?
SELECT 
`Department Referral`, ROUND(AVG(`Patient Waittime`), 2) AS Avg_Waittime
FROM hospital_er
WHERE `Department Referral` IS NOT NULL AND `Department Referral` != 'None'
GROUP BY `Department Referral`
ORDER BY Avg_Waittime DESC;

-- # Q 12: What is the overall percentage of patients admitted versus non-admitted?
SELECT `Patient Admission Flag`, 
       COUNT(*) AS Total_Count,
       ROUND(COUNT(*) * 100.0 / 9216, 2) AS Admission_Percentage
FROM hospital_er
GROUP BY `Patient Admission Flag`;

-- # Q 13: Is there a relationship between Patient Satisfaction Score and Average Wait time?
SELECT 
`Patient Satisfaction Score`, ROUND(AVG(`Patient Waittime`), 2) AS Avg_Waittime
FROM hospital_er
WHERE `Patient Satisfaction Score` IS NOT NULL
GROUP BY `Patient Satisfaction Score`
ORDER BY `Patient Satisfaction Score` DESC;

-- # Q 14: Which Department Referrals have an average patient wait time of more than 35 minutes?
SELECT 
`Department Referral`, ROUND(AVG(`Patient Waittime`), 2) AS Avg_Waittime
FROM hospital_er
WHERE `Department Referral` IS NOT NULL AND `Department Referral` != 'None'
GROUP BY `Department Referral`
HAVING Avg_Waittime > 35;

-- # Q 15: What is the breakdown of Patient Gender within each Department Referral?
SELECT 
`Department Referral`, `Patient Gender`, COUNT(*) AS Total_Patients
FROM hospital_er
WHERE `Department Referral` IS NOT NULL AND `Department Referral` != 'None'
GROUP BY `Department Referral`, `Patient Gender`
ORDER BY `Department Referral`, Total_Patients DESC;

-- # Q 16: What is the average satisfaction score given by male vs female patients?
SELECT 
`Patient Gender`, ROUND(AVG(`Patient Satisfaction Score`), 2) AS Avg_Satisfaction
FROM hospital_er
WHERE `Patient Satisfaction Score` IS NOT NULL
GROUP BY `Patient Gender`;

-- # Q 17: How many patients are classified under 'Patients CM' (Chronic Management)?
SELECT 
`Patients CM`, COUNT(*) AS Patient_Count 
FROM hospital_er 
GROUP BY `Patients CM`;

-- # Q 18: What is the average wait time for Chronic Management patients (CM = 1) vs Normal patients (CM = 0)?
SELECT 
`Patients CM`, ROUND(AVG(`Patient Waittime`), 2) AS Avg_Waittime
FROM hospital_er
GROUP BY `Patients CM`;

-- # Q 19: Find the total number of patients who had a perfect satisfaction score of 10.
SELECT 
COUNT(*) AS Perfect_Score_Count 
FROM hospital_er 
WHERE `Patient Satisfaction Score` = 10;

-- # Q 20: What is the average age of patients referred to the 'Cardiology' department?
SELECT 
ROUND(AVG(`Patient Age`), 2) AS Avg_Cardiology_Age 
FROM hospital_er 
WHERE `Department Referral` = 'Cardiology';

-- # Q 21: Group patients into life stages (Children, Adults, Seniors) and analyze their total visits, wait time, and satisfaction.
SELECT 
    CASE 
        WHEN `Patient Age` < 18 THEN 'Children (0-17)'
        WHEN `Patient Age` BETWEEN 18 AND 60 THEN 'Adults (18-60)'
        ELSE 'Seniors (60+)'
    END AS Age_Group,
    COUNT(*) AS Total_Patients,
    ROUND(AVG(`Patient Waittime`), 2) AS Avg_Waittime,
    ROUND(AVG(`Patient Satisfaction Score`), 2) AS Avg_Satisfaction
FROM hospital_er
GROUP BY Age_Group
ORDER BY Total_Patients DESC;

-- # Q 22: Convert text timestamp to proper format and extract the highest-visited ER months.
SELECT 
    DATE_FORMAT(STR_TO_DATE(`Patient Admission Date`, '%d-%m-%Y %H:%i'), '%Y-%m') AS Admission_Month,
    COUNT(*) AS Total_Visits
FROM hospital_er
GROUP BY Admission_Month
ORDER BY Total_Visits DESC;

-- # Q 23: Which hour of the day receives the maximum number of ER admissions? (Peak Hours Analysis)
SELECT 
    DATE_FORMAT(STR_TO_DATE(`Patient Admission Date`, '%d-%m-%Y %H:%i'), '%h %p') AS Admission_Hour,
    COUNT(*) AS Total_Visits
FROM hospital_er
GROUP BY Admission_Hour
ORDER BY Total_Visits DESC;

-- # Q 24: Rank the departments based on their average patient wait time using DENSE_RANK().
SELECT 
    `Department Referral`,
    ROUND(AVG(`Patient Waittime`), 2) AS Avg_Waittime,
    DENSE_RANK() OVER (ORDER BY AVG(`Patient Waittime`) DESC) AS Wait_Time_Rank
FROM hospital_er
WHERE `Department Referral` IS NOT NULL AND `Department Referral` != 'None'
GROUP BY `Department Referral`;

-- # Q 25: Create a pivot summary showing admission counts by Gender for each Department (Using Conditional Aggregation).
SELECT 
    `Department Referral`,
    SUM(CASE WHEN `Patient Gender` = 'M' THEN 1 ELSE 0 END) AS Male_Count,
    SUM(CASE WHEN `Patient Gender` = 'F' THEN 1 ELSE 0 END) AS Female_Count,
    COUNT(*) AS Total_Count
FROM hospital_er
WHERE `Department Referral` IS NOT NULL AND `Department Referral` != 'None'
GROUP BY `Department Referral`
ORDER BY Total_Count DESC;

-- # Q 26: Find the running total (cumulative sum) of ER visits ordered by admission date.
SELECT 
    Patient_Id, 
    `Patient Admission Date`,
    COUNT(*) OVER (ORDER BY STR_TO_DATE(`Patient Admission Date`, '%d-%m-%Y %H:%i')) AS Cumulative_Visits
FROM hospital_er
LIMIT 100;

-- # Q 27: Determine the monthly conversion percentage of ER visits into actual hospital admissions.
SELECT 
    DATE_FORMAT(STR_TO_DATE(`Patient Admission Date`, '%d-%m-%Y %H:%i'), '%Y-%m') AS Admission_Month,
    COUNT(*) AS Total_ER_Visits,
    SUM(CASE WHEN `Patient Admission Flag` = 'TRUE' THEN 1 ELSE 0 END) AS Total_Admissions,
    ROUND((SUM(CASE WHEN `Patient Admission Flag` = 'TRUE' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Conversion_Rate_Pct
FROM hospital_er
GROUP BY Admission_Month
ORDER BY Admission_Month;

-- # Q 28: Use NTILE(4) to segment patients into 4 groups (Quartiles) based on their wait times to identify outliers.
SELECT 
    Patient_Id, 
    `Department Referral`, 
    `Patient Waittime`,
    NTILE(4) OVER (ORDER BY `Patient Waittime`) AS Wait_Time_Quartile
FROM hospital_er
LIMIT 100;


















