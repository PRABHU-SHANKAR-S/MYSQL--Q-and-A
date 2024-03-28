USE prabhu;

SELECT *
FROM superstore;

-- *******this is some important quetions asked in companies:=

-- 1.find the highest salary
-- 2.find the second highest salary
-- 3.find the weekend or weekday column  (case statement)
-- 4.find the position of first space and second space and third space

-- Q1. What is the difference between COUNT(*), COUNT(expression), 
								-- and COUNT(DISTINCT expression)?

select count(*)
from superstore;					-- it counts all rows present in the table        

select count(order_id)
from superstore;					-- it counts all the rows except the null values

select count(distinct(order_id))
from superstore;					-- it counts only distinct values of given expression and does not count duplicate values

-- Q2. Doing basic Exploratory data analysis (EDA) of the dataset. For example-
		-- How many rows do we have?
        -- How many orders were placed?
		-- How many customers do we have?
		-- How much profit did we make in total?
		-- How many days orders were placed?
		-- What was the highest and lowest sales per quantity ?
        
        select count(*) as n_rows,
			count(distinct(order_id)) as n_orders,
            count(distinct (customer_id)) as n_customers,
            sum(profit) as n_profit,
            count(distinct order_date)as n_date,
            max(sales) as highest_sale,
            min(sales) as lowest_sales
        from superstore;
        
-- Q3- Write a query to get total profit, first order date and latest order date for each category
															
select category,sum(profit) as totalprofit,
min(order_date) as first_order,
max(order_date) as last_order
from superstore
group by category;									-- (each or per) means use the GROUP BY


-- Q4. How many orders were placed on each day?

select order_date,count(distinct(order_id)) as newcol
from superstore
group by order_date;

-- Q5. How many orders were placed for each type of Ship mode? 

select  ship_mode,count(distinct order_id) as newcol
from superstore
group by ship_mode; 
    
-- Q6. How many orders were placed on each day for Furniture Category?

select order_date,count(distinct order_date) as newcol
from superstore
where category="furniture"
group by order_date;

-- Q7. How many orders were placed per day for the days when sales was greater than 1000?
		
        SELECT order_date,count(distinct order_id) as newcol,
        sum(sales) as totalsales
        FROM superstore
        group by order_date
        having sum(sales)>1000;
        
-- Q8. What will below codes return? What is the issue here?
	
		SELECT category, sub_category, SUM(profit) AS profit
		FROM superstore
		GROUP BY category;						-- it will through error beacuase sub_category column not in GROUP BY cluase
        

		SELECT category, SUM(profit) AS profit
		FROM superstore
		GROUP BY category, sub_category;		-- it gives you values but this gives you wrong values,
												-- what you are using in GROUP BY clause should be in SELECT statement
        
-- Q9. How many Sub categories and products are there for each categories?

select category ,count(distinct sub_category) as total_sub,
count(distinct product_id) as total_products
from superstore
group by category;

-- Q10. Find sales, profit and Quantites sold for each categories.

select category,sum(sales) as total_sales,sum(profit)as total_profit,count(distinct(quantity)) as total_quantity
from superstore
group by category;

-- Q11. Write a query to find top 5 sub categories in west region by total quantity sold
											-- select distinct region from superstore;

select sub_category,sum(quantity) as total_quantity
from superstore
where region="West"
group by sub_category
order by sum(quantity) desc
limit 5;

-- Q12. Write a query to find total sales for each region and ship mode combination for orders in year 2020

select region,ship_mode,sum(sales)as total_sales
from superstore
where year(order_date)=2020
group by region,ship_mode;

-- Q13. Find quantities sold for combination of each category and subcategory
select category,sub_category,sum(quantity) as sum_quantity
from superstore
group by category,sub_category;

-- Q14. Find quantities sold for combination of each category and subcategory 
		-- when quantity sold is greater than 2

select category,sub_category,sum(quantity) as sum_quantity
from superstore
where quantity>2
group by category,sub_category;   
        
-- Q15. Find quantities sold for combination of each category and subcategory 
		-- when quantity sold in the combination is greater than 100

SELECT category, sub_category, SUM(quantity) AS total_quantity
FROM superstore
GROUP BY category, sub_category
HAVING total_quantity > 100;

-- Q16. Write a query to find sub-categories where average profit
		--  is more than the (HALF) of the max profit in that sub-category

select sub_category,avg(profit)as avgprofit,0.5*max(profit)as maxprofit
from superstore
group by sub_category
having avg(profit)>0.5*max(profit);

-- OR

-- Write a query to find sub-categories where average profit
--  is more than the (ONE 10th) of the max profit in that sub-category

select sub_category,avg(profit)as avgprofit,0.1*max(profit)as maxprofit
from superstore
group by sub_category
having avg(profit)>0.1*max(profit);

-- Q17. Create the exams table with below script
			
CREATE TABLE exams 
(student_id int, 
subject varchar(20), 
marks int);

INSERT INTO exams VALUES 
(1,'Chemistry',91),
(1,'Physics',91),
(1,'Maths',92),
(2,'Chemistry',80),
(2,'Physics',90),
(3,'Chemistry',80),
(3,'Maths',80),
(4,'Chemistry',71),
(4,'Physics',54),
(5,'Chemistry',79);

select * from exams;

-- 17A. Write a query to find students who have got same marks in Physics and Chemistry.

select student_id,count(subject) as cnt_sub,count(distinct marks)as cnt_marks
from exams
where subject in('Chemistry','Physics')
group by student_id
having count(subject)=2 and count(distinct marks)=1;
