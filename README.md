# Credit-Card-Customer-Segmentation-Default-Risk-Analysis
Credit Card Customer Analysis and Credit Risk Assessment using Excel, SQL and Power BI

# Credit Card Customer Analysis & Credit Risk Assessment

## 📌 Project Overview

This project analyzes customer, credit card, and transaction data to understand customer eligibility, card adoption, spending behavior, and credit risk.

A synthetic dataset was generated using ChatGPT to simulate real-world banking data. The dataset was intentionally designed with common data quality issues such as missing values, duplicates, inconsistent categories, unrealistic values, and outliers to replicate practical data cleaning challenges.

The project follows an end-to-end analytics workflow:

**Data Generation → Data Cleaning → Data Transformation → SQL Analysis → Power BI Dashboard → Business Insights**

---

## 🎯 Business Objectives

The project aims to answer the following business questions:

- How many customers are eligible for a credit card?
- What is the application approval rate?
- How does credit card adoption vary across cities and customer segments?
- Which card types are most widely used?
- What are the major transaction and spending patterns?
- Which customer segments show higher default risk?
- How do salary, CIBIL score, and existing loans relate to default risk?
- Who are the high-value customers based on transaction activity?

---

## 📊 Dataset

The dataset contains three main tables:

### Customers

Customer-level information including:

- Customer ID
- Age
- Gender
- City
- Locality
- Annual Salary
- Employment
- Existing Loans
- CIBIL Score
- Eligibility

### Cards

Credit card master information including:

- Card ID
- Card Type
- Card Limit

### Transactions

Transaction-level information including:

- Transaction ID
- Customer ID
- Card ID
- Transaction Date
- Transaction Amount
- Merchant Category
- Payment Status
- Default Flag

### Dataset Size

- **900 customers**
- **2,300 transactions**
- **824 customers with transactions**
- **418 approved customers**

> Note: The dataset is synthetic and does not represent actual customer or banking data.

---

## 🧹 Data Cleaning & Preparation

Excel was used for initial data cleaning and transformation.

### 1. Customer Count

Total customers were calculated using:

=COUNTA(Customers[customer_id])

### 2. Student Age Correction

Student records with unrealistic ages were corrected:

=IF([@employment]="Student",RANDBETWEEN(18,25),[@age])

###3. Student Salary Correction

Student salaries were adjusted to realistic values:

=IF([@employment]="Student",RANDBETWEEN(0,20000),[@[annual_salary]])

### 4. Existing Loans for Students

Students were assumed to have either zero or one existing loan:

=IF([@employment]="Student",RANDBETWEEN(0,1),[@[existing_loans]])

### 5. Retirement Classification

Customers above 60 were classified as retired:

=IF(Customers[@age]>60,"Retired",Customers[@employment])

Existing loan and CIBIL values were retained.

### 6. Eligibility Recalculation

Eligibility was recalculated based on:

CIBIL Score ≥ 750
Annual Salary ≥ ₹4,00,000
Employment ≠ Unemployed

=IF(AND([@[annual_salary]]>=400000,
        [@[cibil_score]]>=750,
        [@employment]<>"Unemployed"),"Y","N")

### 7. CIBIL Band

Customers were grouped into:
Poor: < 650
Average: 650–749
Good: ≥ 750

=IF([@[Cibil_score]]<650,"Poor",
IF([@[Cibil_score]]<750,"Average","Good"))

### Transaction Data Enrichment

Card type information was brought into the transaction table using INDEX + MATCH

=IFERROR(
INDEX(cards.csv!card[#All],
MATCH([@[card_id]],cards.csv!$A$2:$A$5,0),2),
"NA")

This enriched transaction records with card type information for further analysis.

Card limits were retrieved using VLOOKUP:

=IFERROR(
VLOOKUP([@[card_id]],cards.csv!$A$2:$C$5,3,TRUE),
"NA")

### Power Query

Customers and Transactions were integrated using Power Query.

**Process**
1. Loaded Transactions table into Power Query.
2. Selected New Source → File.
3. Used Merge Queries as New.
4. Selected customer_id as the matching key.
5. Used Left Outer Join.
6. Expanded the required customer columns.
7. Removed the original column-name prefix.
8. Loaded the transformed dataset back into Excel/Power BI.

This created an integrated dataset for customer and transaction-level analysis

### Excel Dashboard Analysis

The dashboard analyses customer demographics, employment characteristics, credit card preferences, and application rejection patterns to identify key trends and customer segments.

**Excel Key Tools: Pivot Tables, Pivot chart, Slicers**

1. Gender Distribution- Distribution of customers across different genders to understand the overall customer composition.

2. Age Group Analysis- Customers are segmented into different age groups to identify the major customer segments within the dataset.

3. City-wise Distribution- Customer distribution across different cities to identify locations with a higher concentration of customers.

4. Rejection Analysis- Examines the most common reason for card rejection among customers

5. Card Type Analysis- Analyses the customer preferences over credit card usage

6. Employment Analysis- Examines customer distribution based on employment category

## SQL Analysis

SQL was used for exploratory analysis and business-oriented analysis.

Key areas analyzed include:

--Customer eligibility
--Application approval and rejection
--Card adoption
--Card type distribution
--Transaction volume
--Transaction value
--Monthly transaction trends
--Merchant category performance
--City-level customer activity
--Customer spending behavior
--Default risk
--CIBIL-based risk segmentation
--Salary-based risk segmentation
--Existing-loan-based risk segmentation
--High-value customers

## Power BI Dashboard

The final Power BI dashboard contains four analytical pages.

--Page 1 - Credit Card Sales Overview
--Page 2 - Customer & Card Analysis
--Page 3 - Transaction & Spending Analysis
--Page 4 - Credit Risk Analysis

## Key Insights

###Customer & Card Adoption

-824 customers participated in transactions.
-418 customers were approved.
-The overall application approval rate was approximately 50.7%.
-Hyderabad had the highest customer count.
-Pune recorded the highest customer adoption rate.
-Platinum was the most widely used card type.
- Note: Not only Eligible customers got approval, but some exceptional customers from Ineligible customer data also got approval.


### Transaction & Spending

--Approximately 2,330 transactions were analyzed.
--Total transaction value was approximately ₹28.7M.
--Electronics generated the highest transaction value among merchant categories.
--Transaction activity varied significantly across cities and card types.
--Higher transaction activity was observed during selected festive-period months.

### Credit Risk

--Customers in the Average CIBIL segment showed higher observed default risk than Good-CIBIL customers.
--The ₹4L–₹8L salary segment recorded the highest observed default rate.
--Customers with two existing loans showed the highest observed default rate.
--Risk patterns varied across employment, age, salary, and geographic segments.
--Poor-CIBIL customers were generally not eligible for credit card approval under the defined eligibility criteria; therefore, their observed default rate should not be interpreted as a meaningful card-default comparison.


##Business Recommendations

Based on the analysis:

--Target high-adoption cities with personalized card campaigns and cross-selling strategies.
--Reward high-value customers by providing limit enhancement and charge waiver
--Monitor customers with multiple existing loans as a potentially higher-risk segment.
--Strengthen credit assessment for customers with weaker CIBIL profiles who meet eligibility criteria.



## Data Limitations

-The dataset is synthetic and was generated for analytical practice.
-It does not represent actual banking customers or transactions.
-Some values were intentionally modified to simulate data quality problems.
-January 2024 contains incomplete data and should not be used for full-year trend conclusions.
-Default-risk observations are based on the synthetic dataset and should not be interpreted as actual banking risk estimates.

## Tools & Technologies
Excel — Data cleaning, transformation and exploratory analysis
Power Query — Data integration and transformation
SQL / PostgreSQL — Data analysis and business queries
Power BI — Data visualization and dashboard development
DAX — Measures and analytical calculations
GitHub — Project versioning and portfolio presentationtion 

