-- ============================================================
-- PROJECT: Employee Attrition & Cost Analysis
-- AUTHOR: Rajnandini Ghadge
-- DOMAIN: HR Analytics
-- DATABASE: hr_analytics
-- TABLE: employees
-- ============================================================

CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;

-- ============================================================
-- 1. TABLE CREATION
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    Employee_ID VARCHAR(10),
    Department VARCHAR(50),
    Job_Role VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Monthly_Salary DECIMAL(10,2),
    Months_Worked INT,
    Training_Cost DECIMAL(10,2),
    Job_Satisfaction INT,
    Performance_Rating INT,
    Overtime VARCHAR(5),
    Attrition VARCHAR(5),
    Attrition_Reason VARCHAR(50),
    Total_Loss DECIMAL(15,2)
);

-- ============================================================
-- 2. DATA VALIDATION
-- ============================================================

SELECT COUNT(*) AS Total_Employees
FROM employees;

SELECT *
FROM employees;

-- ============================================================
-- 3. DEPARTMENT-WISE EMPLOYEE COUNT
-- ============================================================

SELECT
    Department,
    COUNT(*) AS Employee_Count
FROM employees
GROUP BY Department
ORDER BY Employee_Count DESC;

-- ============================================================
-- 4. OVERALL ATTRITION SUMMARY
-- ============================================================

SELECT
    Attrition,
    COUNT(*) AS Employee_Count
FROM employees
GROUP BY Attrition;

-- ============================================================
-- 5. OVERALL ATTRITION RATE
-- ============================================================

SELECT
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Total_Attrition,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees;

-- ============================================================
-- 6. DEPARTMENT-WISE ATTRITION ANALYSIS
-- ============================================================

SELECT
    Department,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;

-- ============================================================
-- 7. ATTRITION BY REASON
-- ============================================================

SELECT
    Attrition_Reason,
    COUNT(*) AS Employee_Count
FROM employees
WHERE Attrition = 'Yes'
GROUP BY Attrition_Reason
ORDER BY Employee_Count DESC;

-- ============================================================
-- 8. SALARY ANALYSIS
-- ============================================================

SELECT
    ROUND(AVG(Monthly_Salary), 2) AS Average_Salary,
    MIN(Monthly_Salary) AS Minimum_Salary,
    MAX(Monthly_Salary) AS Maximum_Salary
FROM employees;

-- ============================================================
-- 9. AVERAGE SALARY BY ATTRITION STATUS
-- ============================================================

SELECT
    Attrition,
    COUNT(*) AS Employee_Count,
    ROUND(AVG(Monthly_Salary), 2) AS Average_Salary
FROM employees
GROUP BY Attrition;

-- ============================================================
-- 10. OVERTIME VS ATTRITION
-- ============================================================

SELECT
    Overtime,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Overtime
ORDER BY Attrition_Rate_Percent DESC;

-- ============================================================
-- 11. TRAINING COST ANALYSIS
-- ============================================================

SELECT
    ROUND(SUM(Training_Cost), 2) AS Total_Training_Cost,
    ROUND(AVG(Training_Cost), 2) AS Average_Training_Cost
FROM employees;

-- ============================================================
-- 12. TOTAL EMPLOYEE-RELATED COST
-- ============================================================

SELECT
    ROUND(SUM(Total_Loss), 2) AS Total_Calculated_Loss
FROM employees;

-- ============================================================
-- 13. HIGH-RISK EMPLOYEES
-- Criteria:
-- Low satisfaction + overtime + attrition
-- ============================================================

SELECT
    Employee_ID,
    Department,
    Job_Role,
    Monthly_Salary,
    Job_Satisfaction,
    Overtime,
    Attrition
FROM employees
WHERE Job_Satisfaction <= 2
  AND Overtime = 'Yes'
  AND Attrition = 'Yes'
ORDER BY Job_Satisfaction ASC;

-- ============================================================
-- 14. DEPARTMENT SALARY & ATTRITION ANALYSIS
-- ============================================================

SELECT
    Department,
    COUNT(*) AS Employees,
    ROUND(AVG(Monthly_Salary), 2) AS Average_Salary,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;

-- ============================================================
-- 15. HIGH-RISK DEPARTMENTS
-- Attrition rate >= 50%
-- ============================================================

SELECT
    Department,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percent
FROM employees
GROUP BY Department
HAVING Attrition_Rate_Percent >= 50
ORDER BY Attrition_Rate_Percent DESC;

-- ============================================================
-- END OF HR ANALYTICS SQL PROJECT
-- ============================================================
