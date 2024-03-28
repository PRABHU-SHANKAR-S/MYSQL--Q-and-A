USE prabhu;

SELECT * from employees;		-- CTE(common table expressions)

-- Q1. write a query to find premium customers from superstore data. 
		-- [ Premium customers are those who have done more orders than average no of orders per customer.]
		 
with cte4 as (
			select customer_id,count(distinct order_id)as orders
			from superstore
			group by customer_id
)
select *
from cte4
where orders > (select avg(orders) from cte4);

-- Q2- write a query to find employees whose salary 
	-- is more than average salary of employees in their department

SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- solving this problem using CTE	

WITH cte as(
			select department_id,avg(salary) as avgsalary
			from employees
			group by department_id
)
select *
from employees as e 
left join cte as c
on e.department_id = C.department_id
where e.salary>C.avgsalary;

-- Q3- write a query to find employees whose age 
	-- is more than average age of all the employees.

SELECT *
FROM employees 
WHERE emp_age > (
    SELECT AVG(emp_age)
    FROM employees
);

-- Q4- write a query to print emp name, salary and dep id 
	-- of highest salaried employee in each department 

select e.*,d.maxSalary
from employees as e
inner join( select department_id,max(salary) as maxSalary
			from employees
			group by department_id) as d
on e.department_id = d.department_id
where e.salary = d.maxSalary;

-- solving this problem with CTE

with cte as(
			select department_id,max(salary) as max_salary
			from employees 
			group by department_id
)
select e.*,d.max_salary
from employees as e
left join cte as d
on e.department_id= d.department_id
where e.salary=d.max_salary;

-- Q5- write a query to print emp name, salary and dep id of 
	-- highest salaried employee overall

select *
from employees
where salary =(
				select max(salary) as max_salary
				from employees
                );

-- Q6- write a query to print product id and total sales 
	-- of highest selling products (by no of units sold) in each category
   
select b.*
from (		SELECT category,product_id,sum(sales) as tota_sales
			FROM SUPERSTORE
			group by category,product_id
	  ) as b
inner join (select category,max(tota_sales) as max_sales
from (
			SELECT category,product_id,sum(sales) as tota_sales
			FROM SUPERSTORE
			group by category,product_id) AS a
group by category
     ) as c
on b.category=c.category
where b.tota_sales=c.max_sales;
   
-- solve this problem using CTE
    
with cte1 as (
				select category,product_id,sum(sales) as sum_sales
				from superstore
				group by product_id,category
),    cte2 as(
				select category,max(sum_sales) as max_sales
				from cte1
				group by category
                )
select cte1.*
from cte1
left join cte2
on cte1.category=cte2.category
where cte1.sum_sales = cte2.max_sales;
    
-- second highest salary using CTE
   
with cte as(
			select *
			from employees
			where salary<>(select max(salary)as max_salary from employees)
           )
select *
from cte
where salary=(select max(salary)as max_salary
from cte);
    
    
    