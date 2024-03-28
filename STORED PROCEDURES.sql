use prabhu;
-- STORED PROCEDURES:=

-- 1. CALL


-- CREATING PROCEDURES 
-- SYNTAX::==

/*		CREATE PROCEDURE PROCEDURE_NAME()
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