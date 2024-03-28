USE prabhu;

-- locking the table 
					-- there are 2 types of locking
                    -- 1.READ:=  EXAMPLE:=
							    lock table employees READ;      -- NOTE:= user can only view this table.
																				-- and it shows another user to RUNNING(error).
                    -- 2.WRITE:= EXAMPLE:=
							    LOCK TABLE employees WRITE;      -- NOTE:= USER CAN write and view the query.
						
-- for UNLOCKING the table:=
							 UNLOCK TABLE;
							 UNLOCK TABLES;
                        
CREATE TABLE UserActivity
(
username VARCHAR(20) ,
activity VARCHAR(20),
startDate DATE,
endDate DATE
);

INSERT INTO UserActivity VALUES 
('Alice','Travel','2020-02-12','2020-02-20'),
('Alice','Dancing','2020-02-21','2020-02-23'),
('Alice','Travel','2020-02-24','2020-02-28'),
('Bob','Travel','2020-02-11','2020-02-18');

SELECT * from UserActivity;

-- Get the second most recent activity. If there is only one activity then return that one also.

with cte as(
			select *,
			dense_rank() over(partition by username order by startdate desc) as rn,
			count(*) over(partition by username) as cnt
			from UserActivity
)
select *
from cte
where rn=2 or cnt=1;

-------------------------------------------------------------

CREATE TABLE exams (
	student_id INT, 
	subject VARCHAR(20), 
	marks INT
	);

INSERT INTO exams VALUES 
(1,'Chemistry',91),
(1,'Physics',91),
(1,'Maths',81),
(2,'Chemistry',80),
(2,'Physics',90),
(3,'Chemistry',80),
(4,'Chemistry',71),
(4,'Physics',54),
(4,'Maths',64);

select * from exams;

-- Find students with same marks in Physics and Chemistry

with cte as (
			select *,
			lag(mARKS) over(partition by student_id order by student_id) as lag_marks
			from exams
			where subject in ('Chemistry','Physics')
)
select student_id
from cte 
where marks=lag_marks;

--------------------------------------------------------------------------------

CREATE TABLE covid(
city VARCHAR(50),
days DATE,
cases INT);

INSERT INTO covid VALUES
('DELHI','2022-01-01',100),
('DELHI','2022-01-02',200),
('DELHI','2022-01-03',300),
('MUMBAI','2022-01-01',100),
('MUMBAI','2022-01-02',100),
('MUMBAI','2022-01-03',300),
('CHENNAI','2022-01-01',100),
('CHENNAI','2022-01-02',200),
('CHENNAI','2022-01-03',150),
('BANGALORE','2022-01-01',100),
('BANGALORE','2022-01-02',300),
('BANGALORE','2022-01-03',200),
('BANGALORE','2022-01-04',400);

select * from covid;

-- Find cities with increasing number of covid cases every day.

with cte as (
			select *,
			cast(dense_rank() over(partition by city order by days) as signed) -
			cast(dense_rank() over(partition by city order by cases) as signed) as diff 
			from covid
  )
  select city 
  from cte
  group by city
  having count(distinct diff)=1;
					-- IMPORTANT:=   cast(column_name as signed) ==== it changes unsigned to signed

-------------------------------------------------------------------------

CREATE TABLE students(
 studentid INT NULL,
 studentname NVARCHAR(255) NULL,
 subject NVARCHAR(255) NULL,
 marks INT NULL,
 testid INT NULL,
 testdate DATE NULL
);

INSERT INTO students VALUES 
(2,'Max Ruin','Subject1',63,1,'2022-01-02'),
(3,'Arnold','Subject1',95,1,'2022-01-02'),
(4,'Krish Star','Subject1',61,1,'2022-01-02'),
(5,'John Mike','Subject1',91,1,'2022-01-02'),
(4,'Krish Star','Subject2',71,1,'2022-01-02'),
(3,'Arnold','Subject2',32,1,'2022-01-02'),
(5,'John Mike','Subject2',61,2,'2022-11-02'),
(1,'John Deo','Subject2',60,1,'2022-01-02'),
(2,'Max Ruin','Subject2',84,1,'2022-01-02'),
(2,'Max Ruin','Subject3',29,3,'2022-01-03'),
(5,'John Mike','Subject3',98,2,'2022-11-02');

SELECT * FROM students;

-- Write a SQL query to get the list of students who scored above average marks in each subject

with cte as(
			select *,
			avg(marks) over(partition by subject)as avg_marks
			from students
)
select *
from cte
where marks > avg_marks;

-- Write a SQL query to get the percentage of students who scored 90 or above in any subject amongst total students
	
select 100.0*(  select count(distinct studentid)
				from students
				where marks>90)/
								(select count(distinct studentid)
								from students) as percentage;

-- Write a SQL query to get the second highest and second lowest marks for each subject

-- second highest marks

with cte as(	
			select *,
			dense_rank() over(partition by subject order by marks desc) as second_hst
			from students
)
select *
from cte
where second_hst=2;
  
-- second lowest marks

SELECT subject, MIN(marks) AS second_lowest_marks
FROM (
		SELECT subject, marks,
		ROW_NUMBER() OVER (PARTITION BY subject ORDER BY marks) AS ranks
		FROM students
) AS ranked_marks
WHERE ranks = 2
GROUP BY subject;

-- For each student and test, identify if their marks increased or decreased from the previous test.

with cte as(
			select *,
			lag(marks) over(partition by studentid order by testid ) as test_mark
			from students
)
select *,
		case 
		when marks>test_mark then 'increased'
		when marks<test_mark then 'decreased'
		else "same"
		end as changed_marks
from cte ;

----------------------------------------------------------------

CREATE TABLE icc_world_cup
(
Team_1 VARCHAR(20),
Team_2 VARCHAR(20),
Winner VARCHAR(20)
);

INSERT INTO icc_world_cup values
('India','SL','India'),
('SL','Aus','Aus'),
('SA','Eng','Eng'),
('Eng','NZ','NZ'),
('Aus','India','India');

SELECT * FROM icc_world_cup;

-- Create three columns - Matches_played, No_of_wins, No_of_losses
	
with cte as(    
			select team_1,
						case
							when team_1=winner then '1'
							else "0"
							end as total_winner
			from icc_world_cup
			union all
			select team_2,
						case
							when team_2=winner then '1'
							else "0"
							end as total_winner
			from icc_world_cup
)
select team_1,
			count(team_1) as matches_played,
			sum(total_winner) as wins,
			count(team_1)-sum(total_winner) as losses
from cte 
group by team_1;

-----------------------------------------------------------------

 
CREATE TABLE events (
ID INT,
event VARCHAR(255),
YEAR INt,
GOLD VARCHAR(255),
SILVER VARCHAR(255),
BRONZE VARCHAR(255)
);

INSERT INTO events VALUES 
(1,'100m',2016, 'Amthhew Mcgarray','donald','barbara'),
(2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith'),
(3,'500m',2016, 'Charles','Nichole','Susana'),
(4,'100m',2016, 'Ronald','maria','paula'),
(5,'200m',2016, 'Alfred','carol','Steven'),
(6,'500m',2016, 'Nichole','Alfred','Brandon'),
(7,'100m',2016, 'Charles','Dennis','Susana'),
(8,'200m',2016, 'Thomas','Dawn','catherine'),
(9,'500m',2016, 'Thomas','Dennis','paula'),
(10,'100m',2016, 'Charles','Dennis','Susana'),
(11,'200m',2016, 'jessica','Donald','Stefeney'),
(12,'500m',2016,'Thomas','Steven','Catherine');

select * from events;

-- PUSH YOUR LIMITS --

-- Write a query to find number of gold medal per swimmers for swimmers who only won gold medals.

-- SUBQUERY:=

select gold,
			count(*) as cnt
from events
where gold  in(
				select silver from events
				union all
				select bronze from events) 
group by gold;

----------------------------------------------------------------

CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    name VARCHAR(20)  NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);

INSERT INTO emp_salary VALUES
(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

SELECT * FROM emp_salary;

-- Write a SQL query to return all employees whose salary is same in same department

-- Using CTE

with cte as(
			select *,
            count(*) over(partition by salary,dept_id) as cnt
			from emp_salary
            )
select *
from cte 
where cnt>1;
	-- Using joins(inner join and left join)

----------------------------------------------------------------------

CREATE TABLE emp_2020
(
emp_id INT,
designation VARCHAR(20)
);

CREATE TABLE emp_2021
(
emp_id INT,
designation VARCHAR(20)
);

INSERT INTO emp_2020 VALUES 
(1,'Trainee'), 
(2,'Developer'),
(3,'Senior Developer'),
(4,'Manager');

INSERT INTO emp_2021 VALUES 
(1,'Developer'), 
(2,'Developer'),
(3,'Manager'),
(5,'Trainee');

-- Find the change in employee status.
	-- Types of status can only be - Promoted, No change, Resigned, New
    
SELECT 
    COALESCE(e1.emp_id, e2.emp_id) AS emp_id,
    CASE
        WHEN e1.designation IS NULL AND e2.designation IS NOT NULL THEN 'New'  	-- Employee is new in 2021
        WHEN e1.designation IS NOT NULL AND e2.designation IS NULL THEN 'Resigned'  	-- Employee resigned in 2021
        WHEN e1.designation = e2.designation THEN 'No change'  	-- Employee designation remains same
        ELSE 'Promoted'  	-- Employee got promoted
    END AS status
FROM emp_2020 e1
CROSS JOIN emp_2021 e2 ON e1.emp_id = e2.emp_id
ORDER BY emp_id;

------------------------------------------------------------------


CREATE TABLE hospital ( 
emp_id INT,
action VARCHAR(10),
time DATETIME);

INSERT INTO hospital VALUES 
('1', 'in', '2019-12-22 09:00:00'),
('1', 'out', '2019-12-22 09:15:00'),
('2', 'in', '2019-12-22 09:00:00'),
('2', 'out', '2019-12-22 09:15:00'),
('2', 'in', '2019-12-22 09:30:00'),
('3', 'out', '2019-12-22 09:00:00'),
('3', 'in', '2019-12-22 09:15:00'),
('3', 'out', '2019-12-22 09:30:00'),
('3', 'in', '2019-12-22 09:45:00'),
('4', 'in', '2019-12-22 09:45:00'),
('5', 'out', '2019-12-22 09:40:00');

SELECT * FROM hospital;

-- Write a SQL Query to find the total number of people present 
	-- inside the hospital
-- 1-out, 2-in, 3-in, 4-in, 5-out

SELECT 
    time,
    SUM(CASE WHEN action = 'in' THEN 1 WHEN action = 'out' THEN -1 ELSE 0 END) AS total_people_inside
FROM hospital
GROUP BY time
ORDER BY time;
