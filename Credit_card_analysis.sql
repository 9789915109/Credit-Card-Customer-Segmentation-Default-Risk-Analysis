create schema Banking;

CREATE TABLE banking.customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    locality VARCHAR(100),
    employment VARCHAR(30),
    annual_salary INT,
    existing_loans INT,
    cibil_score INT,
    is_eligible VARCHAR(5),
    age_band VARCHAR(20),
    recalculated_eligibility VARCHAR(5),
    salary_band VARCHAR(30),
    cibil_band VARCHAR(20)
);

Select * from banking.customers;

Create table banking.transactions(
Transaction_id int Primary key,
customer_id  int,
Card_Type varchar(20),
Card_Limit int,
card_id int,
purchase_date date,
purchase_amount decimal (10,2),
merchant_category varchar(30),
Payment_status varchar(20),
Applied_but_rejected varchar(20),
Rejection_reason varchar(50)
);
Select * from banking.transactions;

Select count(*) from banking.transactions;
--o/p: Total transactions: 2300

select count(*) from banking.customers;
--o/p: Total customers: 900

select count(distinct customer_id)
from banking.transactions;
--o/p: 824

-- Customers who owns a card--
select count(distinct customer_id)
from banking.transactions
where card_type is not null;

--o/p: 418

select count(distinct customer_id)
from banking.transactions
where card_type is null;

-- rejected customers: 406


--Gender wise analysis--
select gender,count(*) from banking.customers
group by gender;

-- In our analysis male customers are higher than Female. 

--City wise analysis--
select city,count(*) as total_customers from banking.customers 
group by city
order by total_customers desc;

-- Customers data is mostly from Metropolitan cities like Hyd, Chennai, Delhi, Pune, Bangalore and Mumbai

--Customers by employment type--
select employment ,count(*) as total_customers from banking.customers 
group by employment
order by total_customers desc;

-- Most of the customers are Salaried class people, only a few of them are unemployed. 
--Customers by age group--
select 
case
	when age between 0 and 24 then '<25'
	when age between 25 and 35 then '25-35'
	when age between 36 and 60 then '35-60'
	Else '60+'
End as age_group, 
count(*) as total_customers 
from banking.customers
group by age_group
order by age_group;

-- Most of the customers are belongs to 35-60 age group category

--Customer wise Card type Distribution--
select card_type, count(distinct customer_id) as total_cards
from banking.transactions
where card_type is not null
group by card_type
order by total_cards desc;

# Business Insights- 
--Most Customers Possess Platinum cards

--Card Type By Salary Group--
select 
case
	when annual_salary < 400000 then 'Below 4L'
	when annual_salary between 400000 and 800000 then '4L-8L'
	when annual_salary between 800000 and 1200000 then '8L-12L'
	else 'Above 12L'
end as salary_group, t.card_type, count(distinct t.customer_id) total_customers
from banking.transactions t
join banking.customers c
on c.customer_id= t.customer_id
where t.card_type is not null
group by salary_group, t.card_type
order by salary_group,total_customers desc;

## Business Insights:
--Signature card is predominantly used by high-salary-class people--
--Above 12L customers have high card usage--
--Platinum card is highly used by high-income customers
--Even below 4L income customers possess Signature card indicates salary not only the criteria for providing credit card

--Average Purchases per transaction--
select card_type, 
       Round(avg(purchase_amount),0) as avg_purchase
from banking.transactions
where card_type is not null
group by card_type
order by avg_purchase desc;

## Business Insights:
--No significant differences observed in the purchases as per card variant--

-- Which card_type users have more defaulters--
select card_type, payment_status, count(distinct customer_id) as total_defaulters
from banking.transactions
where card_type is not null and payment_status='Default'
group by card_type, payment_status;

## Business Insights: gold users have high defaulters

-- Salary wise defaulters--
select 
case 
	when annual_salary < 400000 then 'Below 4L'
	when annual_salary between 400000 and 800000 then '4L-8L'
	when annual_salary between 800000 and 1200000 then '8L-12L'
	else 'Above 12L'
end as salary_group, t.payment_status, count(distinct t.customer_id) as total_count 
from banking.transactions t
join banking.customers c
on t.customer_id=c.customer_id
where t.payment_status= 'Default'
group by salary_group, t.payment_status
order by total_count desc;

--Business Insight- 
--Above 12L people have highest defaulters

--Merchant Category Analysis--
--which merchant category brings more transaction volume and revenue
select merchant_category,
 round(sum(purchase_amount),0) as transaction_volume,
 round(avg(purchase_amount),0) as avg_transaction_value
from banking.transactions
where merchant_category is not null
group by merchant_category
order by transaction_volume desc;

--Business Insight:
--Electronics category followed by travel, fuel, dining, and groceries is generating highest transaction volume


-- Monthly trend--
--##How do transaction volumes change over time--

select date_trunc('month',purchase_date) as month_,
count(*) as total_transactions,
round(sum(purchase_amount),0) as transaction_volume
from banking.transactions
where purchase_date is not null
group by month_
order by month_;

--Business Insight:
--December had highest transactions indicates year_end shopping, seasonal spending 

--Highest Spending Salary Group--

select 
case 
	when c.annual_salary < 400000 then 'Below 4L'
	when c.annual_salary between 400000 and 800000 then '4L-8L'
	when c.annual_salary between 800000 and 1200000 then '8L-12L'
	else 'Above 12L'
end as salary_group,
round(sum(t.purchase_amount),0) as transaction_volume
from banking.transactions t
join banking.customers c
on t.customer_id= c.customer_id
group by salary_group
order by transaction_volume desc;

-- Top 10 spending customers--
select c.customer_id,
round(sum(t.purchase_amount),0) as transaction_volume
from banking.transactions t
join banking.customers c
on t.customer_id= c.customer_id
where t.purchase_amount is not null
group by c.customer_id
order by transaction_volume desc
limit 10;

--Within each salary group, which card type contributes highest transaction volume--
select
case 
	when c.annual_salary < 400000 then 'Below 4L'
	when c.annual_salary between 400000 and 800000 then '4L-8L'
	when c.annual_salary between 800000 and 1200000 then '8L-12L'
	else 'Above 12L'
end as salary_group,
count(distinct t.customer_id) as total_customers, 
count(t.transaction_id) as total_transactions,
round(sum(t.purchase_amount)) as trans_vol, 
round(sum(t.purchase_amount)/count(distinct t.customer_id),2)as avg_spend_per_customer,
t.card_type
from banking.transactions t
join banking.customers c
on t.customer_id=c.customer_id
where t.card_type is not null
group by salary_group, t.card_type
order by salary_group;

with trans as (select
case 
	when c.annual_salary < 400000 then 'Below 4L'
	when c.annual_salary between 400000 and 800000 then '4L-8L'
	when c.annual_salary between 800000 and 1200000 then '8L-12L'
	else 'Above 12L'
end as salary_group,
count(distinct t.customer_id) as total_customers, 
count(t.transaction_id) as total_transactions,
round(sum(t.purchase_amount)) as trans_vol, 
round(sum(t.purchase_amount)/count(distinct t.customer_id),2)as avg_spend_per_customer,
t.card_type
from banking.transactions t
join banking.customers c
on t.customer_id=c.customer_id
where t.card_type is not null
group by salary_group, t.card_type
order by salary_group)
select * 
from (select *, row_number() over(partition by salary_group order by trans_vol desc) as rn 
from trans) t
where rn=1
order by trans_vol desc;

--Business Insight: 1.Platinum is the most dominant card type among High Salary group customers
--2.Gold cards generated high transaction volume among 8L-12L customers
--3. Although the ₹4–8 lakh and Below ₹4 lakh groups show higher average spend per customer, these segments have very small customer bases (6 & 31 customers, resp). 
--These averages should therefore be interpreted cautiously and validated with a larger sample before drawing business conclusions.

----Top 5 Cities by transaction volume--

select c.city, round(sum(t.purchase_amount),0) as trans_vol
from banking.customers c
join banking. transactions t
on t.customer_id= c.customer_id
group by c.city
order by trans_vol desc
limit 5;

--Business Insight: 
--People from Hyderabad followed by Pune, making highest transactions 


-- High Spending customer in every city--

with city_spend as
(select 
      c.customer_id,
	  c.city,
	  t.card_type,
      count(t.transaction_id) as total_trans,
	  round(sum(t.purchase_amount),0) as trans_volume
from banking.transactions t
join banking.customers c
on t.customer_id= c.customer_id
where t.purchase_amount is not null and t.card_type is not null
group by c.customer_id,c.city,t.card_type)
select * 
from (select *, row_number() over(partition by city order by trans_volume desc) as rn 
from city_spend) t
where rn=1;

-- Business Insight: 
--Customers with top spending are identified from each city, these customers can be rewarded by increasing their limit

--Monthly Growth %---
select 
TO_CHAR(date_trunc('month',purchase_date),'Mon YYYY') as mon, 
sum(purchase_amount) as mon_spend,
lag(sum(purchase_amount))over (order by date_trunc('month',purchase_date))as prev_mon,
round(
(
sum(purchase_amount)-
lag(sum(purchase_amount))over 
(order by date_trunc('month',purchase_date))
)*100/ lag(sum(purchase_amount))over (order by date_trunc('month',purchase_date))
,0) as growth_per
from banking.transactions
where purchase_date is not null
group by date_trunc('month',purchase_date)
ORDER BY date_trunc('month', purchase_date);

--Business Insights: 
--Jan 2024 data is incomplete to drive conclusions.
-- December has highest spending
-- High growth % observed in Oct (35%) compared to September

--Which city have highest credit card adoption rate?
select c.city,
count(distinct t.customer_id) as total_customers,
count(distinct 
case 
	when t.card_type is not null then c.customer_id 
end)  as card_holders,
Concat(round(
count(distinct 
case 
	when t.card_type is not null then c.customer_id 
end)*100.0/ count(distinct c.customer_id),0
),'%') as adoption_rate
from banking.transactions t
left join banking.customers c
on t.customer_id= c.customer_id
group by c.city
order by adoption_rate desc;

Business Insights: 
--Out of 824 customers, 418 customers are holding cards with highest credit card adoption in Pune with 58% followed by Bangalore 52%.
-- Also more or less card holders are adopted in the given metropolitan cities.

--Which age group has highest rejection rate--

select 
case
	when age between 0 and 24 then '<25'
	when age between 25 and 35 then '25-35'
	when age between 36 and 60 then '35-60'
	Else '60+'
End as age_group, 
count(distinct
case
	when applied_but_rejected ='Y' then t.customer_id end
)as rejected_customers,
round(count(distinct
case
	when applied_but_rejected ='Y' then c.customer_id end
) *100.0/count(distinct t.customer_id),0) as rejection_rate,
round(avg(c.annual_salary),0) as avg_salary, 
round(avg(c.cibil_score),0)as avg_cibilscore,
round(avg(c.existing_loans),0) as existing_loans
from banking.transactions t
left join banking.customers c
on t.customer_id= c.customer_id
group by age_group
order by avg_salary desc;

--Business Insight:
--Rejection Rate is higher among less than 25 age group(75%)
--Only 34% Rejection rate is observed among senior citizens
--People from age group 25-35 & 35-60 have rejection_rate with 48% and 43% resp

--Are the senior citizens less likely to get rejected because of their avg salary/cibil or existing loans?
--Age Group vs avg_salary/avg_cibil/existing_loans

select age_band,
round(avg(annual_salary),0) as avg_salary, 
round(avg(cibil_score),0)as avg_cibilscore,
round(avg(existing_loans),0) as existing_loans
from banking.customers
group by age_band
order by avg_salary desc;

--Business insight:
--1.Less than 25+ age_group has lower income and with low cibil, these are the main reasons for high rejection rate among this age_group
--2. 60+ age group with descent income and good_cibil are less likely to get rejected
-- Eligibility is calculated in the synthetic dataset(default) provided 750+ score, Rs. 4,00,000 above salary

select count (*) 
from banking.customers  c
join banking.transactions t
on c.customer_id=t.customer_id
where c.is_eligible ='Y' and t.applied_but_rejected='Y';

--o/p: 0
-- This indicates only rejected customers got approval.

-- Which rejection rate is most common?

select rejection_reason,count(*)
from banking.transactions
where rejection_reason is not null
group by rejection_reason
order by count desc;

--This indicates Salary is the main reason for the rejection.
-- This observation is getting matched with the Age_group vs salary,cibil,existing_loans analysis