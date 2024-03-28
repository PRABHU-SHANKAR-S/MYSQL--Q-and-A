USE prabhu;

CREATE TABLE IF NOT EXISTS employees(
emp_id INT,
emp_name VARCHAR(20),
department_id INT,
salary INT,
manager_id INT,
emp_age INT
);

			INSERT INTO employees VALUES 
			(1, 'Ankit', 100, 10000, 4, 30),
			(2, 'Mohit', 100, 15000, 5, 48),
			(3, 'Vikas', 100, 10000,4,37),
			(4, 'Rohit', 100, 5000, 2, 16),
			(5, 'Mudit', 200, 12000, 6,55),
			(6, 'Agam', 200, 12000,2, 14),
			(7, 'Sanjay', 200, 9000, 2,13),
			(8, 'Ashish', 200,5000,2,12),
			(9, 'Mukesh',300,6000,6,51),
			(10, 'Rakesh',300,7000,6,50);

SELECT * FROM employees;

CREATE TABLE department(
dep_id INT,
dep_name VARCHAR(20)
);

			INSERT INTO department VALUES
			(100, 'Analytics'),
			(300, 'IT');

select * from department;

-- Q1. Given EMPLOYEES and DEPARTMENT table. How many rows will be returned after using left, right, inner, full outer joins
    -- 1.INNER JOIN:=
					select count(*) from employees as e
					inner join department as d 
					on e.department_id=d.dep_id;   
    
    -- 2.RIGHT JOIN
					select count(*) from department as d
					right join employees as e
					on e.department_id=d.dep_id;
    
    -- 3.LEFT JOIN
					select count(*) from department as d
					left join employees as e
					on e.department_id=d.dep_id;
    
	-- 4.CROSS JOIN												-- there is no FULL OUTER JOIN in MySQL database
					select count(*) from employees as e
					cross join department as d
					on e.department_id=d.dep_id;
    
-- Q2. Create new column for department name in the EMPLOYEES table

select e.*,d.dep_name
from employees as e
left join department as d
on e.department_id=d.dep_id;

-- Q3. In case if the department does not exist, the default department should be "NA".

select e.*,d.dep_name,
case
when d.dep_name is null then "NA" else d.dep_name    -- when you use the null clause don't use OPERATERS use the IS clause
end as newcol
from employees as e
left join department as d
on e.department_id=d.dep_id;

-- Q4. Find employees which are in Analytics department.

select e.*,d.dep_name
from employees as e
left join department as d
on e.department_id=d.dep_id
where d.dep_name="Analytics";

-- Q5. Find the managers of the employees

-- using self join one or same table 
select e.*,d.emp_name
from employees e
left join employees d
on d.emp_id=e.manager_id;

-- Q6. Find all employees who have the salary more than their manager salary.

select e.*,d.emp_name as manager_name
from employees as e
left join employees as d
on e.manager_id=d.emp_id       			-- in self join ON condition important 
where e.salary> d.salary;

-- Q7. Find number of employees in each department

select d.dep_name,count(*) as cnt_name
from employees as e
left join department as d              
on e.department_id=d.dep_id
group by d.dep_name;

				-- count(*)-count(column_name) it gives total null values, only that column has
					select count(*)-count(department_id) from employees;

-- Q8. Find the highest paid employee in each department

SELECT department_id,max(salary) as total_salary
from employees 
group by department_id;

-- Q9. Which department recieves more salary

SELECT d.dep_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN department d 
ON e.department_id = d.dep_id
GROUP BY d.dep_name
ORDER BY total_salary DESC;

-- Q10. What is cross join? What it can be used for?
			-- in this you will not join the column you will join the rows

select * 
from employees              -- it joins like multiplication (EMPLOYEES * DEPARTMENT)
cross join department;


-- *******these are the some the important concepts:=
					-- UNION/UNION ALL
					-- INTERSECT
					-- EXCEPT


-- how to use FULL OUTER JOIN in MYSQL

-- in order like this:=
					-- LEFT JOIN
					-- UNION ALL
					-- RIGHT JOIN
					-- WHERE LEFT IS NULL

-- EXAMPLE:=
			SELECT emp_id
			from employees as e
			left join department as d
			on e.emp_id=d.emp_id
			union all
			SELECT emp_id
			from employees as e
			left join department as d
			on e.emp_id=d.emp_id
			where e.emp_id is null;			-- so do not use full outer join in MySQL


