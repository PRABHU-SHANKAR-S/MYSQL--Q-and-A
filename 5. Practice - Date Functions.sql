USE prabhu;

CREATE TABLE emp_info (
				empno INT,
				ename VARCHAR(10),
				job VARCHAR(9),
				mgr INT,
				hiredate DATE,
				sal INT,
				comm INT,
				dept INT
);

INSERT INTO emp_info VALUES
    (1,'JOHNSON','ADMIN',6,'1990-12-17',18000,NULL,4),
    (2,'HARDING','MANAGER',9,'1998-02-02',52000,300,3),
    (3,'TAFT','SALES I',2,'1996-01-02',25000,500,3),
    (4,'HOOVER','SALES I',2,'1990-04-02',27000,NULL,3),
    (5,'LINCOLN','TECH',6,'1994-06-23',22500,1400,4),
    (6,'GARFIELD','MANAGER',9,'1993-05-01',54000,NULL,4),
    (7,'POLK','TECH',6,'1997-09-22',25000,NULL,4),
    (8,'GRANT','ENGINEER',10,'1997-03-30',32000,NULL,2),
    (9,'JACKSON','CEO',NULL,'1990-01-01',75000,NULL,4),
    (10,'FILLMORE','MANAGER',9,'1994-08-09',56000,NULL,2),
    (11,'ADAMS','ENGINEER',10,'1996-03-15',34000,NULL,2),
    (12,'WASHINGTON','ADMIN',6,'1998-04-16',18000,NULL,4),
    (13,'MONROE','ENGINEER',10,'2000-12-03',30000,NULL,2),
    (14,'ROOSEVELT','CPA',9,'1995-10-12',35000,NULL,1);

SELECT * FROM emp_info;

-- some of the important DATE functions in MYSQL:=

SELECT hiredate, 
				ADDDATE(hiredate, INTERVAL -10 YEAR) as newDate,        -- in MSSQL use the DATEADD
				CURDATE() as currentDate,
				CURRENT_TIME() as currentTime,
				TIMESTAMPDIFF(YEAR, hiredate, CURDATE()) as differnce,
				DAYname(hiredate) as Nameofday,
				day(hiredate) as no_day,
				month(hiredate) as nmonth,
				YEAR(hiredate) as nmonth,
				HOUR(CURRENT_TIME()) as ntime,
				NOW(),
				WEEKDAY(CURDATE()) as weekday,
				WEEKOFYEAR(CURDATE()) as weekofYear
FROM emp_info;

-- Q1. Decrease one year from Hiredate.

select hiredate,adddate(hiredate,interval -1 year) as newdate
from emp_info;
    
-- Q2. Calculate the tenure of the employees (in months) in the company.

select hiredate,timestampdiff(month,hiredate,curdate()) as newdate
from emp_info;

-- Q3. Extract Day, Month, Year, Weekday from hiredate.
	
select hiredate,
		day(hiredate),
		month(hiredate),
		year(hiredate),
		weekday(hiredate)
from emp_info;
    
-- Q4. Find employees who were hired on Monday.

select *
from emp_info
where dayname(hiredate)="Monday";

-- Q5. Find employees who were hired after 1996.

	select *
    from emp_info
    where year(hiredate)>1996;
    
-- Q6. Find employees who were hired after 1996 and before 1998.

	select * 
    from emp_info
    where year(hiredate)>1996 and year(hiredate)<1998;
    
-- Q7. Find years where more than 2 employees were hired.

select year(hiredate),count(*) as cnt
from emp_info
where year(hiredate)
group by year(hiredate)
having count(*)>2;

