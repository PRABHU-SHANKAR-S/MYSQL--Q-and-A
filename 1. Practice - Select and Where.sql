use prabhu;  -- which database you want to use

-- 1- write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

select count(*) from superstore 
where customer_name like "_a_d%";

-- 2- write a sql to get all the orders placed in the month of dec 2020 (352 rows) 

select count(*) 
from superstore
where order_date>="2020-12-01" and
order_date<="2020-12-31";

-- 3- write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' 
															--   and ship_date is after nov 2020 (944 rows)

select count(*) 
from superstore
where ship_mode not in("first class","standard class")
and ship_date>"2020-12-01";

-- 4- write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

select count(*)
from superstore
where customer_name not like "A%n";

-- 5- write a query to get all the orders where profit is negative (1871 rows)

select count(profit) 
from superstore
where profit<0;

-- 6- write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

select count(*)
from superstore 
where quantity<3 or profit=0;


-- 7- your manager handles the sales for South region and he wants you to create a report of all
-- the orders in his region where some discount is provided to the customers (815 rows)

select distinct region from superstore;    -- for your reference

select count(*)
from superstore 
where region="South" and discount>0;

-- 8- write a query to find top 5 orders with highest sales in furniture category 

select customer_id,max(sales) as highest_sale from superstore
where category="furniture"
group by customer_id,sales
order by sales desc
limit 5;

-- 9- write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

select count(*) from
superstore
where category in('Furniture','Technology')
and year(order_date)=2020;

-- 10 -write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

SELECT count(*)
FROM superstore
WHERE YEAR(Order_Date) = 2020 AND YEAR(Ship_Date) = 2021;
