-- 1.real bussiness use case:=

create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);

insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');

select * from tickets;

create table holidays
(
holiday_date date
,reason varchar(100)
);

insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from holidays;


-- write a sql to find bussiness day between create date and resolved date by excluding weekends and public holidays.

with cte as (
select *
from tickets left join holidays on (holiday_date between create_date and resolved_date) and 
(dayname(holiday_date) <> 'Saturday' and dayname(holiday_date) <> 'Sunday')
)
select ticket_id,create_date,resolved_date,
datediff(resolved_date,create_date) - 2*(week(resolved_date)-week(create_date)) - count(holiday_date) actual_biz_days
from cte
group by ticket_id,create_date,resolved_date;

------------------------------------------------------------------------------------------------------

-- 2.amazon sql interview quetions:=

create table hospital ( 
emp_id int
, action varchar(10)
, time datetime
);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00'); 	-- 1 is OUT
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');		-- 2 is IN
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');		-- 3 is IN
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');		-- 4 is IN
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');	-- 5 is OUT

select * from hospital;

-- write a sql to find the total number of peaple present INSIDE the hospital

with cte as(
SELECT emp_id,
max(CASE WHEN action='in' then time end) as intime,
max(CASE WHEN action='out' then time end) as outtime
FROM hospital
group by emp_id
)
select emp_id,intime
from cte
where intime>outtime or outtime is null;

----------------------------------------------------------------------
-- 3.Airbnb sql interview quetion
 
create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);

insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room');

select * from airbnb_searches;

/* find the room types that are searched most no of times.
	output the room type alonside the no of searches for it.
    if the filter for room types has more than one room type ,
    consider each unique room type as a separate row .
    sort the result based on the no of searches in desc order. */


with room as(
select sum(case when filter_room_types like '%entire%' then 1 else 0 end) as en,
sum(case when filter_room_types like '%private%' then 1 else 0 end) as pr,
sum(case when filter_room_types like '%shared%' then 1 else 0 end) as sh
from airbnb_searches
)
select 'entire home' as  value,en cnt_value from room
union all
select 'private room' as value,pr cnt_value from room
union all
select 'shared room' as value,sh cnt_value from room
order by cnt_value desc;

------------------------------------------------------------------------------------

-- 4.SQL Interview Question for Senior Data Engineer Position in Poland

CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    name NVARCHAR(20)  NOT NULL,
    salary NVARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

select * from emp_salary;

-- write a sql to return all employee whose salary is same in same department


with cte as (
select dept_id,salary
from emp_salary
group by dept_id,salary
having count(*)>1
)
select e.*
from emp_salary as e
inner join cte as d
where e.dept_id=d.dept_id and e.salary=d.salary
order by dept_id;

-- write a sql to return all employee whose salary is NOT same in same department

with cte as (
select dept_id,salary
from emp_salary
group by dept_id,salary
having count(*)=1			-- only changes here
)
select e.*
from emp_salary as e
inner join cte as d
where e.dept_id=d.dept_id and e.salary=d.salary
order by dept_id;

--------------------------------------------------------------

-- 5. most asked join based quetions in AMAZON for data engineer

/*  table-1:=  1,1,1,1,1
	table-2:=  1,1,1,1,1,1,1,1,1,1
	
    inner join: 50
    left join:  50
    right join: 50
    cross join: 50  */
    
/*	table-1:= 1,1,1,1,1
	table-2:= 2,2,2,2,2,2,2,2,2,2
    
    inner join: 0
    left join:  5
    right join: 10
    cross join: 15		*/
    
    create table t1(
    id1 int
    );
    
    insert into t1(id1) values(1),
    (2),(3),(4),(5);
    
    create table t2(
    id2 int
    );
    
    insert into t2(id2) values(1),
    (2),(3),(4),(5),(6),(7),(8),(9),(0);
    
select * from t1;
 select * from t2;
 
 select * from t1 inner join t2 on t1.id1=t2.id2;  
 
  select * from t1 left join t2 on t1.id1=t2.id2; 
  
   select * from t1 right join t2 on t1.id1=t2.id2; 
   
    select count(*) from t1 cross join t2 on t1.id1=t2.id2; -- it works on the what condition you are giving
    
----------------------------------------------------------------------------------------------------

-- 6.L&T SQL quetion

create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);

insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);

select * from employee;

-- write a sql query to print highest and lowest salary emp in each department

		-- using the cte, case, join
with cte as(
select dep_id,max(salary) as max_sal,min(salary) as min_sal
from employee 
group by dep_id
)
select e.dep_id,
max(case when salary=max_sal then emp_name end) as max_sal_name,
min(case when salary=min_sal then emp_name end) as min_sal_name
from employee as e
inner join cte as d
on e.dep_id= d.dep_id
group by e.dep_id;

		-- WINDOW FUNCTIONS, cte, case
        
with cte as(
select *,
dense_rank() over(partition by dep_id order by salary desc) as rank_desc,
dense_rank() over(partition by dep_id order by salary ) as rank_asc
from employee
)
select dep_id,
max(case when rank_desc=1 then emp_name end) as max_sal_name,
max(case when rank_asc=1 then emp_name end) as min_sal_name
from cte
group by dep_id;

--------------------------------------------------------------------------------

-- 7. data analyst as a start up company

create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);

insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00');

select * from call_start_logs;

create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00');

select * from call_end_logs;

	/* write a query to get the start time and end time of each call from below 2 tables.also create a column
	of call duration in minutes. please do take into account that there will be multiple calls from one phone number  
	and each entry in start table has a corresponding entry in end table.    */
    
select a.phone_number,a.start_time,b.end_time,abs(minute(end_time)-minute(start_time)) as minutes
from(
select *,row_number() over(partition by phone_number order by start_time desc) as st from call_start_logs ) a
inner join 
(select *,row_number() over(partition by phone_number order by end_time desc) as et from call_end_logs ) b
on a.phone_number=b.phone_number and a.st=b.et;

-------------------------------------------------------------------------------------------------------

-- 8.solving INFOSYS sql puzzle

create table input (
id int,
formula varchar(10),
value int
);
insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);  

select * from input;

-- solve the puzzle

select a.id,a.formula,a.value, 
case when MID(a.formula,2,1)='+' then a.value+b.value else a.value-b.value end as new_value 
from input as a 
inner join input as b 
WHERE  a.id=cast(LEFT(a.formula,1) as UNSIGNED) and b.id=cast(RIGHT(a.formula,1)as UNSIGNED)
order by a.id;

----------------------------------------------------------------------------------------------

-- 9.ameriprise LLC company interview quetions

create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);

insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');
select * from Ameriprise_LLC;

-- condidtion , if criteria1 and criteria2 both are Y and a minimum of 2 members , should have Y then the output should be Y else N.

-- aam zindagi
with cte as(
select teamid,count(*) as no_of_memebers
from Ameriprise_LLC
where criteria1='y' and criteria2='y'
group by teamid
having count(*)>=2
)
select a.*,c.*,
case when criteria1='y' and criteria2='y' then 'y' else 'n' end as qualified_members
from Ameriprise_LLC as a
left join cte as c
on a.teamid=c.teamid;

-- mentos zindagi
select *,
case when criteria1='y' and criteria2='y' and
sum(case when criteria1='y' and criteria2='y' then 1 else 0 end) over(partition by teamid)>=2 then 'y' else 'n' end as qualified_members
from Ameriprise_LLC ;

---------------------------------------------------------------------------------------------------------------

-- 10.sql interview quetion in tiger analytics for data engineering position

create table family 
(
person varchar(5),
type varchar(10),
age int
);

insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);
select * from family;

-- adult= child

with cte_adult as(
select *,row_number() over(order by person) as rn
from family  
where type='Adult'
),
cte_child as(
select *,row_number() over(order by person) as rn
from family  
where type='Child'
)
select a.person,c.person
from cte_adult as a
left join cte_child as c on a.rn=c.rn;

-- oldest adult = youngest child

with cte_adult as(
select *,row_number() over(order by age desc) as rn  -- only changes here
from family  
where type='Adult'
),
cte_child as(
select *,row_number() over(order by age asc) as rn	-- only changes here
from family  
where type='Child'
)
select a.person,a.age as adult_age ,c.person,c.age as child_age
from cte_adult as a
left join cte_child as c on a.rn=c.rn;

-------------------------------------------------------------------------------

-- 11.PWC sql interview quetion 

create table company_revenue 
(
company varchar(100),
year int,
revenue int
);

insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);

select * from company_revenue;

-- find the company only whose revenue is increasing every year .
-- NOTE:= suppose a company revenue is increasing for 3 years and a very next year revenue is dipped 
					-- in that case it should not come in output.
 
 with cte as(
SELECT *,
revenue- lag(revenue,1,0) over(partition by company order by year) as revenue_diff
from company_revenue
)
select company
from cte 
where company not in(select company from cte where revenue_diff<0)
group by company;

-------------------------------------------------------------------------------------

-- 12.SpringCT data analyst sql interview quetion

create table people
(id int primary key not null,
 name varchar(20),
 gender char(2));

create table relations
(
    c_id int,
    p_id int,
    FOREIGN KEY (c_id) REFERENCES people(id),
    foreign key (p_id) references people(id)
);

insert into people (id, name, gender)
values
    (107,'Days','F'),
    (145,'Hawbaker','M'),
    (155,'Hansel','F'),
    (202,'Blackston','M'),
    (227,'Criss','F'),
    (278,'Keffer','M'),
    (305,'Canty','M'),
    (329,'Mozingo','M'),
    (425,'Nolf','M'),
    (534,'Waugh','M'),
    (586,'Tong','M'),
    (618,'Dimartino','M'),
    (747,'Beane','M'),
    (878,'Chatmon','F'),
    (904,'Hansard','F');

insert into relations(c_id, p_id)
values
    (145, 202),
    (145, 107),
    (278,305),
    (278,155),
    (329, 425),
    (329,227),
    (534,586),
    (534,878),
    (618,747),
    (618,904);
    
select * from people;
select * from relations;

-- write a query that prints the names of a child and his parents in individual columns respectively 
			-- in order of the name of the child.


SELECT c.name AS Child_Name,
       MAX(CASE WHEN p.gender = 'F' THEN p.name END) AS Mother_Name,
       MAX(CASE WHEN p.gender = 'M' THEN p.name END) AS Father_Name
FROM relations AS r
INNER JOIN people AS p ON r.p_id = p.id
INNER JOIN people AS c ON r.c_id = c.id
GROUP BY c.id, c.name;

------------------------------------------------------------------------------------------

-- 13.icc world cup 2023 points table using sql

create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup values(4,'SA','SL','SA');
INSERT INTO icc_world_cup values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup values(12,'PAK','IND','IND');
INSERT INTO icc_world_cup values(12,'SA','IND','DRAW');
select * from icc_world_cup;

with cte as(
select team,sum(matches_played) as matches_played,sum(wins) as wins from
(
select team_1 as team,count(*) as matches_played,
sum(case when team_1=winner then 1 else 0 end) as wins
from icc_world_cup group by team_1
union all
select team_2 as team,count(*) as matches_played,
sum(case when team_2=winner then 1 else 0 end) as wins
from icc_world_cup group by team_2)as wins
group by team
)
select *,matches_played-wins as loses,2*wins as points
from cte
order by wins desc;

-------------------------------------------------------------------------------------

-- 14.a tiger analytics set of 2 sql interview problems

CREATE TABLE flights 
(
    cid VARCHAR(512),
    fid VARCHAR(512),
    origin VARCHAR(512),
    Destination VARCHAR(512)
);

INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f1', 'Del', 'Hyd');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f2', 'Hyd', 'Blr');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f3', 'Mum', 'Agra');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f4', 'Agra', 'Kol');

select * from flights;

-- find the origin and final destination for the each cid.

select o.cid,o.origin,d.destination
from flights as o
inner join flights as d
on o.destination=d.origin;

------------------------------------------------------------------------------------
-- 14.b

CREATE TABLE sales 
(
    order_date date,
    customer VARCHAR(512),
    qty INT
);

INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C1', '20');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C2', '30');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C1', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C3', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C5', '19');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C4', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C3', '13');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C5', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C6', '10');
select * from sales;

-- find the count of new customer added in each month
select monthname(order_date) as month_name,count(customer) as new_customer 
from(
		select *,
		row_number() over(partition by customer order by order_date) as rn
		from sales ) as cnt_tbl
where rn=1
group by monthname(order_date);

-------------------------------------------------------------------------------

-- 15. PWC sql interview quetion for data analyst position

create table sources(id int, name varchar(5));

create table target(id int, name varchar(5));

insert into sources values(1,'A'),(2,'B'),(3,'C'),(4,'D');
insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');

select * from sources;
select * from target;

-- answer

(select id, 'new in source' as value from sources where id not in (select id from target))
union
(select id, 'new in target' as value from target where id not in (select id from sources))
union
(select s.id, 'mismatch' as value from sources s
inner join target t on s.id = t.id and s.name <> t.name);

---------------------------------------------------------------------------------------

-- 16.google sql interview quetion

create table namaste_python (
file_name varchar(25),
content varchar(200)
);

insert into namaste_python values ('python bootcamp1.txt','python for data analytics 0 to hero bootcamp starting on Jan 6th')
,('python bootcamp2.txt','classes will be held on weekends from 11am to 1 pm for 5-6 weeks')
,('python bootcamp3.txt','use code NY2024 to get 33 percent off. You can register from namaste sql website. Link in pinned comment');

select * from namaste_python;

-- find the words which are repeating more than once considering all the rows of constant columns

-- this answer is for MsSQL database

/*		select value as word ,count(*) as cnt_of_world
		from namaste_python
		cross apply string_split(content.' ')
		group by value
		having count(*)>1                                   */
        