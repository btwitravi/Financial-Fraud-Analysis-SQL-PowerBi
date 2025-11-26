/*------------------ Financial Froud Analysis ------------------*/
Create DataBase Financial;
Use Financial;

/*--------------------------- Data Preparation & Cleaning Process ----------------------------*/
-- Create Table for Importing Data
CREATE TABLE Fraud (
    Transaction_Id INTEGER PRIMARY KEY,
    User_Id INTEGER,
    Amount DECIMAL(15 , 2 ),
    Transaction_Type VARCHAR(30),
    Merchant_Category VARCHAR(50),
    Country VARCHAR(10),
    Hour INTEGER,
    Device_risk_Score DECIMAL(10 , 2 ),
    Ip_risk_Score DECIMAL(10 , 2 ),
    Is_Fraud INTEGER
);

-- View Overwise all Records
Select*from Fraud;

-- Update Fraud O to Legitimate & 1 to fraudelent
-- first update Data Type
Alter Table Fraud modify is_fraud varchar(25);
UPDATE Fraud 
SET 
    IS_fraud = CASE
        WHEN Is_Fraud = 0 THEN 'Legitimate'
        WHEN Is_Fraud = 1 THEN 'Fraudelent'
    END
WHERE
    is_Fraud IN (0 , 1);

-- Update Country Column
Alter Table Fraud modify Country Varchar (30);
select distinct(Country) from Fraud;
UPDATE Fraud 
SET 
    Country = CASE
        WHEN Country = 'US' THEN 'United States'
        WHEN Country = 'FR' THEN 'France'
        WHEN Country = 'TR' THEN 'Turkey'
        WHEN Country = 'UK' THEN 'Unied Kingdom'
        WHEN Country = 'DE' THEN 'Germany'
        WHEN Country = 'NG' THEN 'Nigeria'
    END
WHERE
    Country IN ('US' , 'FR', 'TR', 'UK', 'DE', 'NG');


-- Q1 Write a query to calculate the total transaction amount for fraud and non-fraud transactions across each hour of the day.
SELECT 
    is_fraud, Hour, SUM(amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY Is_Fraud , Hour
ORDER BY Hour ASC;

-- Q2 Write a query to calculate the total transaction amount for fraud and non-fraud cases across each transaction type.
SELECT 
    Transaction_Type,
    Is_Fraud,
    SUM(Amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY Transaction_Type , Is_Fraud
ORDER BY Transaction_Amount DESC; 

-- Q3 Write a query to calculate the total transaction amount for fraud and non-fraud cases across each merchant category.
SELECT 
    Merchant_Category, Is_Fraud, SUM(Amount) as Transaction_Amount
FROM
    Fraud
GROUP BY Merchant_Category , Is_Fraud; 

-- Q4.Write a query to calculate the total transaction amount for fraud and non-fraud transactions across each country.
SELECT 
    Country, Is_Fraud, SUM(Amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY Country , Is_Fraud
ORDER BY Transaction_Amount DESC;

-- Q5 Analyze user activity by calculating the total number of transactions per user.
SELECT 
    User_ID, COUNT(User_ID) AS Customer
FROM
    Fraud
GROUP BY User_id
ORDER BY Customer DESC;

-- Q6 Write a query to calculate the total transaction amount for fraudulent and legitimate transactions.
SELECT 
    Is_Fraud, SUM(Amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY is_Fraud;


/* ------------------------- Save Query in View ----------------------------------- */ 
-- Q1.
Create View Hourly_Fraud as SELECT 
    is_fraud, Hour, SUM(amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY Is_Fraud , Hour
ORDER BY Hour ASC;

select*from Hourly_Fraud;

-- Q2
Create view Transaction_Type as SELECT 
    Transaction_Type,
    Is_Fraud,
    SUM(Amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY Transaction_Type , Is_Fraud
ORDER BY Transaction_Amount DESC; 

Select * from Transaction_Type;

-- Q3 
Create View Merchant_Fraud as SELECT 
    Merchant_Category, Is_Fraud, SUM(Amount) as Transaction_Amount
FROM
    Fraud
GROUP BY Merchant_Category , Is_Fraud; 

Select * from Merchant_Fraud;

-- Q4 
Create View Country_Fraud as SELECT 
    Country, Is_Fraud, SUM(Amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY Country , Is_Fraud
ORDER BY Transaction_Amount DESC;

Select*from Country_Fraud;

-- Q5 
Create View Customer as SELECT 
    User_ID, COUNT(User_ID) AS Customer
FROM
    Fraud
GROUP BY User_id
ORDER BY Customer DESC;

-- Q6 
Create view Fraud_Amount_Status as SELECT 
    Is_Fraud, SUM(Amount) AS Transaction_Amount
FROM
    Fraud
GROUP BY is_Fraud;

select*from Fraud_Amount_Status;