

with data as (select
id, name, department, salary,
lag(salary, 1) over (order by salary, id) as prev
from employees 
order by salary, id)

select id, name, department, salary, prev, round(((salary - prev)/salary) *100)   as diff from data

-- or
select
name, department, salary,
round(
(salary - lag(salary, 1) over w)*100.0 / lag(salary, 1) over w
) as diff
from employees
window w as (order by salary, id)
order by salary, id;

-- lag and lead salary
select
name, department,
lag(salary, 1) over w as prev,
salary,
lead(salary, 1) over w as next
from employees
window w as (order by salary)
order by salary, id;

name    dep     prev    sal next
Diane	hr		        70	78
Bob	    hr	    70	    78	84
Emma	it	    78	    84	90
Grace	it	    84	    90	96
Cindy	sales	90	    96	96
Dave	sales	96	    96	100
Alice	sales	96	    100	104
Henry	it	    100	    104	104
Irene	it	    104	    104	120
Frank	it	    104	    120	



-- Comparing each salary to min/max salary of each department
select
name, department,
salary,
min(salary) over w as min_dep,
max(salary) over w as max_dep
from employees
window w as (partition by department)
order by department

name   dep      sal min max
Diane	hr	    70	70	78
Bob	    hr	    78	70	78

Emma	it	    84	84	120
Grace	it	    90	84	120
Henry	it	    104	84	120
Irene	it	    104	84	120
Frank	it	    120	84	120

Cindy	sales	96	96	100
Dave	sales	96	96	100
Alice	sales	100	96	100


-- answer the same
select
name, department, salary,
first_value(salary) over w as low,
last_value(salary) over w as high
from employees
window w as (
partition by department
order by salary
rows between unbounded preceding and unbounded following
)
order by department, salary, id;
--> i think just remove order by in windows 
--> this technique help frame match with partitions (maybe frame is good for rolling average on 1 partition)


-- City salary ratio
-- There is an employees table. For each employee, we want to know the ratio of
-- their salary to the maximum city salary (in %):

select
name, city, salary,
round(
salary*100.0 / last_value(salary) over w
) as percent
from employees
window w as (
partition by city
order by salary
rows between unbounded preceding and unbounded following
)
order by city, salary, id;



-- filter be executed before window fuction ----> cause wrong results --> let filter on the results set of windows calculation

with data as (select
name, city, department, salary,
sum(salary) over  w as budget_by_dep,
from employees
window w as (partition by department)
order by department,salary)

select * from data where city = 'London'