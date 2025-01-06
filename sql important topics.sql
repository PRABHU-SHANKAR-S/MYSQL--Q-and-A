use prabhu;
-- STORED PROCEDURES:=

-- 1. CALL


-- CREATING PROCEDURES 
-- SYNTAX::==

/*		CREATE PROCEDURE PViewsROCEDURE_NAME()
			write a queries here		
            you can create multiple queries	
            if you write a multiple queries if end the statements with (  DELIMETER //  queries  //)
			you can pass also(	DELIMETER ; 	)	*/
            
-- EXAMPLE:=
			
            DELIMITER //
            create procedure sample_procedure()
            select *
            from employees;
            //
          
-- to view the PROCEDURE

		CALL sample_procedure();
        
-- if multiple statements to run you have to run
			delimiter //
			create procedure sample_procedure1()
            begin
            select * 
            from covid;
            
            select *
            from employees;
            end
            //
            
            call sample_procedure1();
            
-- dropping the procedure

			drop procedure sample_procedure1;
            
-- user can change the conditions or queries.
		delimiter //
        create procedure sample_procedure1(in var1 int)    -- create variables for user to change (INPUT)
        select *
		from employees
        where emp_id= var1 ;								   -- defining the variables
        //
        
-- now creating the view procedure with variables

		call sample_procedure1(5);
        
-- to only view the stored procedures
        delimiter //
        create procedure sample_procedure2(out var1 int)					-- output only
        select avg(salary)
        INTO var1											-- defining variables
        from employees;
        //
     
        call sample_procedure2(@avg_salary);       -- [it only stores]here whatever runs in var1 that stores in [ avg_salary ]
        
-- you can also write like this by difining the stored procedures.
		
			select *
			from employees 
			where salary > @avg_salary;
 
-- to view avg_salary

			select @avg_salary;		
            
-- creating the IN and OUT both

		create procedure sample_procedure3(in var3 int, out var4 text);
        
-- 2. EXPLAIN CALL

		EXPLAIN employees;
        
        

-- DCL(data control language)
				-- 1.GRANT:=
							GRANT SELECT,INSERT
							ON prabhu.employees
							TO prabhuss@localhost;   -- this should be in exact name
                
				-- 2.REVOKE:=
							REVOKE SELECT,INSERT
							FROM prabhu.employees
							TO prabhuss@localhost;
                            
-- some important topics:=
select * from employees;
-- 1.VIEWS:=
			CREATE VIEW sample_view as(				-- CREATING VIEWS
			SELECT emp_name,emp_id
			FROM employees				  -- views cannot require storage it store the query
			);
            
            SELECT * FROM sample_view; 				-- to see the VIEWS
            
-- CREATING TABLE with existing table:=

							CREATE TABLE sample_table as(				
							SELECT emp_name,emp_id
							FROM employees				  
							);
                            
            -- important quetions 
            -- 1.difference between VIEWS and STORED PROCEDURES
            -- 2.difference between VIEWS and CTE
            
            
-- INDEXES:=   ( it is used for execution time when table has millions of rows )

			 SHOW INDEXES FROM employees;
             
             CREATE INDEX sample_index ON employees(emp_id);
             CREATE INDEX sample_index_dep ON employees(department_id);
             
             -- combination of two columns:=
             CREATE INDEX sample_index_emp_dep ON employees(emp_id, department_id);
             
             -- dropping the index:=
             DROP INDEX sample_index ON employees;
             
-- TRIGGERS:=		[theory pat is important]

DELIMITER //
CREATE TRIGGER sample_trigger
BEFORE INSERT ON employees FOR EACH ROW
BEGIN
IF NEW.EMP_AGE <18 THEN SET NEW.EMP_AGE = 18;
END IF;
END //
DELIMITER ;

-- AFTER|BEFORE INSERT|UPDATE|DELETE
-- NEW|OLD
				-- INSERT- NEW
				-- UPDATE- NEW|OLD


-- FUNCTIONS:=

-- creating functions

DELIMITER //
CREATE FUNCTION get_department(depart_id INT) RETURNS TEXT deterministic
BEGIN
DECLARE abc TEXT ;
		SELECT dep_name
		INTO abc
		FROM department
		WHERE dep_id = depart_id;
		RETURN abc;
END //
DELIMITER ;

SELECT *, get_department(department_id) as new_col
FROM employees;

SELECT get_department(100);
SELECT get_department(200);
SELECT get_department(300);