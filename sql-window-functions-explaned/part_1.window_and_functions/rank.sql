select
dense_rank() over w as "rank",
name, department, salary
from employees
window w as (order by salary desc)
order by "rank", id;



select
dense_rank() over w as "rank",
name, department, salary
from employees
window w as (order by salary desc);
--> result set is maybe not stable 


select
dense_rank() over w as "rank",
name, department, salary
from employees
window w as (order by salary desc)
order by "rank", id;
---> should explicit order of results by using order by of main query


select
dense_rank() over w1 as r_asc,
dense_rank() over w2 as r_desc,
name, salary
from employees
window
w1 as (order by salary asc),
w2 as (order by salary desc)
order by salary, id;
--> multiple window 




select
dense_rank() over w as rank,
name, department, salary
from employees
window w as (order by name)
order by rank, id;



-- rating slalary with partition by department 

select
dense_rank() over w as "rank",
name, department, salary
from employees
window w as (partition by department order by salary desc)
order by department, rank, id

1	Bob	    hr	    78
2	Diane	hr	    70

1	Frank	it	    120
2	Henry	it	    104
2	Irene	it	    104
3	Grace	it	    90
4	Emma	it	    84

1	Alice	sales	100
2	Cindy	sales	96
2	Dave	sales	96


-- Salary rating by city
select
dense_rank() over w as "rank",
name, city, salary
from employees
window w as (partition by city order by salary desc)
order by city, rank, id

1	Frank	Berlin	120
2	Irene	Berlin	104
3	Alice	Berlin	100
4	Cindy	Berlin	96
5	Grace	Berlin	90

1	Henry	London	104
2	Dave	London	96
3	Emma	London	84
4	Bob	    London	78
5	Diane	London	70


-- Groups
-- Let’s divide the employees into three groups according to their salary:
-- high-paid,
-- medium-paid,
-- low-paid.
--> kind of bucketing (number is the number of partition not number of partition's member) over a number field - not partition by category field 

select
ntile(3) over w as tile,
name, department, salary
from employees
window w as (order by salary desc)
order by salary desc, id;

1	Frank	it	    120
1	Henry	it	    104
1	Irene	it	    104
1	Alice	sales	100

2	Cindy	sales	96
2	Dave	sales	96
2	Grace	it	    90

3	Emma	it	    84
3	Bob	    hr	    78
3	Diane	hr	    70

-- partition by city, each group of city bucket in 2 partition by salary
-- ntile(2) ở ngoài cùng - partition và order thì như bthg
select
ntile(2) over w as tile,
name, city, salary
from employees
window w as (partition by city order by salary)
order by city, salary desc 

1	Grace	Berlin	90
1	Cindy	Berlin	96
1	Alice	Berlin	100

2	Irene	Berlin	104
2	Frank	Berlin	120


1	Diane	London	70
1	Bob	    London	78
1	Emma	London	84

2	Dave	London	96
2	Henry	London	104


-- “Precious” colleagues for each department
-- Suppose we want to find out the highest-paid people in each department:

with data as (
select
id, name, department, salary,
dense_rank() over w as emp_rank
from employees
window w as (
partition by department
order by salary desc
)
)
select
id, name, department, salary
from data
where emp_rank = 1;
