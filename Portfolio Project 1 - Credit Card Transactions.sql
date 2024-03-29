-- SQL porfolio project.
-- download credit card transactions dataset from below link :
-- https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india
-- import the dataset in sql server with table name : credit_card_transcations
-- change the column names to lower case before importing data to sql server.Also replace space within column names with underscore.
-- (alternatively you can use the dataset present in zip file)
-- while importing make sure to change the data types of columns. by defualt it shows everything as varchar.

-- write 4-6 queries to explore the dataset and put your findings 
use prabhu;
select * from credit_card;
select count(distinct city) from credit_card;
select distinct card_type from credit_card; 
select distinct exp_type from credit_card; 



-- solve below questions:=

-- 1- write a query to print top 5 cities with highest spends(amount) and their percentage contribution of total credit card spends 

with total_spends as(
			select sum(amount) as total_amount
			from credit_card
),
city_spends AS (
			select city,sum(amount) as city_amount
			from credit_card
			group by city
)
select city,city_amount,
round((city_amount/(select total_amount from total_spends))*100,2) as percentages   -- percentage formula (VALUE/TOTAL VALUE)*100
from city_spends
order by city_amount desc
limit 5;


-- 2- write a query to print highest spend month for each year and amount spent in that month for each card type

WITH cte1 as(
			SELECT card_type, 
				   YEAR(transaction_date) yt,
				   MONTH(transaction_date) mt, 
				   SUM(amount) as total_spend
			FROM credit_card
			GROUP BY card_type, 
					 YEAR(transaction_date), 
                     MONTH(transaction_date)
), cte2 as(
			SELECT *, 
			DENSE_RANK() OVER(PARTITION BY card_type ORDER BY total_spend DESC) as rn
			FROM cte1
)
SELECT *
FROM cte2
WHERE rn =1;

-- 3- write a query to print the transaction details(all columns from the table) for each card type when
	-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

WITH cte1 as(
			SELECT *, 
			SUM(amount) OVER(PARTITION BY card_type ORDER BY transaction_date, transaction_id) as total_spend
			FROM credit_card
),   cte2 as(
			SELECT *,
            DENSE_RANK() OVER(PARTITION BY card_type ORDER BY total_spend) as rn  
			FROM cte1 
			WHERE total_spend >= 1000000
)
SELECT *
FROM cte2
WHERE rn=1;
    
-- 4- write a query to find city which had lowest percentage spend for gold card type

WITH city_spend AS (
					SELECT city,card_type,
                    SUM(amount) AS total_amount,
					SUM(CASE WHEN card_type = 'Gold' THEN amount END) AS gold_spend
					FROM credit_card						
					GROUP BY city,card_type						
) 
SELECT city,
			sum(gold_spend)*1.0 / sum(total_amount) AS percentage_spend
FROM city_spend
GROUP BY city
HAVING count(gold_spend)>0 and sum(gold_spend)>0
ORDER BY percentage_spend;
 
-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with cte as(
			select city,exp_type, 
					dense_rank() over(partition by city order by sum(amount) desc) as expense_rank_desc,
					dense_rank() over(partition by city order by sum(amount) asc) as expense_rank_asc
					from credit_card
					group by city,exp_type
)
select
city,
max(case when expense_rank_desc=1 then exp_type end) as highest_expense_type,
max(case when expense_rank_asc=1 then exp_type end) as lowest_expense_type
from cte
group by city;

-- 6- write a query to find percentage contribution of spends by females for each expense type
					
select exp_type,
ROUND((SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) *1.0/ SUM(amount)), 2) AS percentage_contribution
from credit_card
group by exp_type;


-- 7- which card and expense type combination saw highest month over month growth in Jan-2014

WITH monthly_expense AS (
				SELECT
					card_type,exp_type,year(transaction_date) as yt,month(transaction_date) as mt,
					SUM(amount) AS monthly_amount
				FROM credit_card
				GROUP BY
					card_type,exp_type,year(transaction_date),month(transaction_date)
), cte2 as(
			SELECT *, 
			LAG(monthly_amount,1) OVER(PARTITION BY card_type, exp_type ORDER BY yt,mt) as prev_month
			FROM monthly_expense
)
SELECT *,
    (monthly_amount - prev_month) AS month_growth
FROM cte2
WHERE prev_month IS NOT NULL AND yt='2014' AND mt='1'
ORDER BY month_growth DESC
LIMIT 1;

-- 8- during weekends which city has highest total spend to total no of transcations ratio 

    SELECT 
        city,
        sum(amount) / count(*) AS spend_to_transaction_ratio  		-- ratio formula:= SUM(amount)/COUNT(*)
    FROM credit_card
    WHERE DAYOFWEEK(transaction_date) IN (1, 7)                     -- or DAYNAME(transaction_date) in ('Saturday','Sunday')
    GROUP BY city
	ORDER BY spend_to_transaction_ratio DESC
	LIMIT 1;

-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city

WITH cte as(
	SELECT *,
    ROW_NUMBER() OVER(PARTITION BY city ORDER BY transaction_date, transaction_id) as rn
	FROM credit_card
)
SELECT city, TIMESTAMPDIFF(DAY, MIN(transaction_date), MAX(transaction_date)) as datediff1
FROM cte
WHERE rn=1 or rn=500
GROUP BY city
HAVING COUNT(1)=2
ORDER BY datediff1
LIMIT 1; 


-- once you are done with this create a github repo to put that link in your resume. Some example github links:
-- https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/tree/master/Advanced%20SQL%20for%20Application%20Development
-- https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/COVID%20Portfolio%20Project%20-%20Data%20Exploration.sql