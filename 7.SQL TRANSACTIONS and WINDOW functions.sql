use prabhu;

-- CONSTRAINTS:=
				-- 1.NOT NULL
				-- 2.UNIQUE
				-- 3.PRIMARY KEY
				-- 4.FOREIGN KEY
				-- 5.CHECK
				-- 6.DEFAULT
				-- 7.AUTO_INCREMENT


-- TRANSACTIONS:=
				-- 1.COMMIT
				-- 2.ROLLBACK
				-- 3.SAVEPOINT
				-- 4.SET Transaction
				-- 5.SET Constraint
		
					-- IMPORTANT NOTE:= it only supports "DML" Commands
    
					-- ACID Properties:=
										-- 1.ATOMICITY
										-- 2.CONSISTENCY
										-- 3.ISOLATION
										-- 4.DURABILITY
                                        
-- 1.COMMIT

SET AUTOCOMMIT =0; -- OFF --  this only used for local computer to changes only in your account it does not change in other accounts
SET AUTOCOMMIT =1; -- ON

COMMIT;				  -- It changes in all the other account or other user account

-- 2.ROLLBACK

START TRANSACTION;     -- This is first step

update employees 
set emp_name="prabhu";

update employees 
set emp_name="madhu";

update employees 
set emp_name="taru";

ROLLBACK;           -- IT rollback to the actual table 


-- 3.SAVEPOINT

START TRANSACTION;

update employees 
set emp_name="prabhu";

					savepoint save1;

update employees 
set emp_name="madhu";

					savepoint save2;

update employees 
set emp_name="taru";

					savepoint save3;

rollback to save2;    -- rollback to the 'madhu'
rollback to save1;	  -- rollback to the 'prabhu'

ROLLBACK;


-- *****WINDOW FUNCTIONS:=

-- SYNTAX:=

	/*	SELECT coulmn_name(S), 
		 window_function(cloumn_name2)
		 OVER([PARTITION BY column_name1] [ORDER BY column_name3]) AS new_column
		FROM table_name;   */
        
       

-- 	GROUP BY													   	SQL PARTITION BY

-- We get a limited number of records using the Group By clause   	 We get all records in a table using the PARTITION BY clause.

-- It gives one row per group in result set. For example, we get   	 It gives aggregated columns with each record in the specified table.
-- a result for each group of CustomerCity in the GROUP BY clause.

                                                               --  	  We have 15 records in the Orders table. In the query output of SQL PARTITION BY,
															   -- 	  we also get 15 rows along with Min, Max and average values.


 
--    WINDOW nonaggregate functions.

-- 1. ROW_NUMBER()
	-- example:=
				 select *,
				 row_number() over (partition by department_id order by emp_name) as ron_umber
				 from employees;
                 
-- using WINDOW FUNCTIONS in CTE.
				-- second highest salary on each department
				WITH CTE as(
							select *,
							row_number() over (partition by department_id order by emp_name) as row_numbers
							from employees
				) 
				select *
				from cte
				where row_numbers=2;
                 
-- 2.RANK():=
				select *,
				rank() over ( partition by department_id order by salary ) as rank_numbers
				from employees;
                            
-- 3.DENSE_RANK():=
				select *,
				dense_rank() over ( partition by department_id order by salary ) as rank_numbers
				from employees;
                            
		-- highest salary or second highest salary usind this
				with t1 as(
                            select *,
							dense_rank() over ( partition by department_id order by salary desc) as rank_numbers
							from employees
                            )
				select *
				from t1
				where rank_numbers=1;
        
-- 4.LAG():=  	 to access previous rows data as per deined value
							
				select *,
				lag(salary) over ( order by salary desc) as lag_numbers           -- in lag(salary,2) you can also pass the values
				from employees;
                            
				select *,
				lag(salary) over ( partition by department_id order by salary desc) as lag_numbers           
				from employees;
                            
                            -- NOTE :=
                            -- when you pass the (partition by department_id) it gives you null values for each department 
                            -- to know how many departments are there [select count(distinct depatment_id) from employees]
                            -- then you count how many null values will be there for LAG().
                           
-- 5.LEAD():=
				select *,
				lead(salary) over ( order by salary desc) as lead_numbers           -- in lead(salary) you cannot pass the values
				from employees;

-- 6.CUME_DIST()
-- 7.FIRST_VALUE()
-- 8.LAST_VALUE()
-- 9.NTH_VALUE()
-- 10.NTILE()
-- 11.PERCENT_RANK()


-- WINDOW aggregate functions
-- 1.SUM()
				select *,
                sum(salary) over(order by salary,emp_id) as aggregate_value
                from employees;
                
                select *,
                sum(salary) over(partition by department_id order by salary,emp_id) as aggregate_value
                from employees;

-- 2.AVG()

				select *,
                avg(salary) over(order by salary,emp_id) as aggregate_value
                from employees;
                
                -- employes salary is higher than average salary 
                with cte as(
							select *,
							avg(salary) over(partition by department_id) as avg_value
							from employees
                )
                select *
                from cte 
                where salary>avg_value;
             
             -- use in the OVER():=
								   -- FOLLOWING
								   -- PRECEDING
								   -- CURRENT ROW
               
                select *,
                sum(salary) over(order by emp_id rows between 2 preceding and current row) as avg_value
                from employees;
                
                select *,
                sum(salary) over(order by emp_id rows between current row and 1 following) as avg_value
                from employees;

-- COUNT()
-- MAX()
-- MIN()										
-- BIT_AND()
-- BIT_OR()
-- BIT_XOR()
-- JSON_ARRAYAGG()
-- JSON_OBJECTAGG()
-- STDDEV_POP(), STDDEV(), STD()
-- STDDEV_SAMP()
-- VAR_POP(), VARIANCE()
-- VAR_SAMP()

