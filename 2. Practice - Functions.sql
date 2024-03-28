USE prabhu;

SELECT * FROM superstore; 

-- You should orderly write the queries by using this commands

/*				SELECT
				FROM
				JOIN 
				WHERE
				GROUP BY 
				HAVING
				ORDER BY
				LIMIT								*/
                
-- this is order of execution in SQL

/*				FROM
				JOIN
				WHERE 
				GROUP BY
				HAVING
				SELECT
				ORDER BY
				LIMIT								*/

-- these are the some of SQL string functions:=

SELECT row_id, product_name, customer_name,
			left(customer_name,4) as useLEFT,
			right(customer_name,5) as useRIGHT, 
			substr(customer_name,3,4) as useSUBSTR,
			length(customer_name) as useLENGTH,
			instr(customer_name,"a") as useINSTR,			-- this gives fisrt position of "a". 			 
			replace(customer_name,"a","--") as useREPLACE,   	
			reverse(customer_name) as useREVERSE,
			concat(row_id,"   ",customer_name) as useCONCAT,
			upper(customer_name) as useUPPER,
			lower(customer_name) as useLOWER
FROM superstore;

-- Q1. Change the Category "Office Supplies" to "School Supplies".
						-- select distinct category from superstore;

select category, 
replace(category,"Office Supplies","school supllies") as changecategory 
from superstore;

-- Q2. Change the Category "Office Supplies" to "School Supplies" only when Ship Mode is "Second Class".
-- select distinct ship_mode from superstore;

select category,ship_mode,
case
when ship_mode="Second Class" then replace(category,"Office Supplies","school supllies")
else category
end as newcolumn
from superstore;

-- Q3. Get the first three letters of Customer Name and make them capital.

select customer_name,left(upper(customer_name),3)as newcolumn
from superstore ;

-- OR

select customer_name,upper(left(customer_name,3))as newcolumn
from superstore;

-- Q4. Get the first name of Customer Name. (Hint: Find the occurence of the first space)

SELECT customer_name,SUBSTRING_INDEX(Customer_Name, ' ', 1) AS FirstName
FROM superstore;

-- OR

select customer_name,
left(customer_name,instr(customer_name, " ") -1) as newcolomn
from superstore;

-- Q5.A. Get the last name of Customer Name. Get the last word from the Product Name.

select customer_name,
right(customer_name,length(customer_name)-instr(customer_name," ") )as lastname 
from superstore;

-- OR

SELECT customer_name,SUBSTRING_INDEX(customer_name, ' ', -1) AS LastName
FROM superstore;

-- last word from product name

select product_name,
reverse(left(reverse(product_name),instr(reverse(product_name)," ")-1))as newcolumn
from superstore;
				-- you should know about functions what should do inside this things ,like string and integer how it works

-- Q5.B. Get the middle name of Customer Name.

SELECT customer_name,SUBSTRING_INDEX(SUBSTRING_INDEX(customer_name, ' ', 2), ' ', -1) AS MiddleName
FROM superstore;

-- Q6. Divide Profit by Quantity. 

select 1.0*profit/quantity as newcolumn
from superstore;

		-- Did you notice anything strange? What can be done to resolve the issue?
        
-- Q7. Write a query to get records where the length of the Product Name is less than or equal to 10.

select product_name
from superstore
where length(product_name)<=10 ;

-- Q8. Get details of records where first name of Customer Name is greater than 4.

select customer_name
from superstore
where instr(customer_name," ")>5;

-- OR

select customer_name
from superstore
where length(substring_index(customer_name," ",1))>4;

-- Q9. Get records from alternative rows.

-- (for odd rows)
		select * 
		from superstore
		where row_id %2 =1;    		-- HERE 1 defines the odd rows

-- (for even rows)
		select * 
		from superstore
		where row_id % 2 =0;		-- here 0 defines the even rows

-- Q10. Create a column to get both Category and Sub Catergory. For example: "Furniture - Bookcases".

select category,sub_category,concat(category," - ",sub_category) as combined
from superstore;

-- Q11. Remove last three characters for the Customer Name.

select customer_name,
left(customer_name,length(customer_name)-3) as named
from superstore;

-- Q12. Get the records which have smallest Product Name.

select min(length(product_name)) as newcol
from superstore;

select *
from superstore
where length(product_name) =5;

-- Q13. Get the records where the Sub Category contains character "o" after 2nd character.

select *
from superstore
where sub_category like"__o%";

-- Q14. Find the number of spaces in Product Name.

select product_name,
length(product_name)-length(replace(product_name," ","")) as newcol
from superstore;

-- Q15. finding vowels as in first letter

select city,left(city,1) as newcity
from superstore
where left(city,1) in("a","e","i","o","u");

-- Q16. find second letter as vowels

select city,substr(city,2,1) as newcity
from superstore 
where substr(city,2,1) in('a','e','i','o','u');

-- Q17. find the first_name and last name then concat the both 

SELECT customer_name,CONCAT(
    SUBSTRING_INDEX(Customer_Name, ' ', 1), 
    ' ', 
    SUBSTRING_INDEX(Customer_Name, ' ', -1)
) AS FullName
FROM superstore;

