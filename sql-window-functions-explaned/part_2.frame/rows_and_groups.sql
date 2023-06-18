

-- There is an employees table. For each employee, we want to know the
-- following:
-- the salary of the previous employee (among their colleagues in the
-- same department);
-- the maximum salary in the department.

-- prev = first_value of frame (1 preceeding and unbounded follwing)  - first value will be not null and using lag the first value will be null
-- max = last_value of the same frame
---> can be that (without using max) as the 1 partition have order by (important to remember that 1 partition is sorted)

select id, name, department, salary,
first_value(salary) over w as prev_salary,
last_value(salary) over w as max_salary_by_dep
from employees
window w as (
partition by department 
order by salary
rows between 1 PRECEDING and UNBOUNDED FOLLOWING 
)
order by department, salary, id;




--- group frame (not support by duckdb ) ---------< execute/ practice online
-- https://antonz.org/sql-window-functions-book/rows.gif 
-- https://antonz.org/sql-window-functions-book/groups.gif 


select
name, department,
count(*) over w as cnt
from employees
window w as (
order by department
groups between unbounded preceding and current row
)
order by department, id;

--> order by department is a way define of grouping by department ??



-- There is an employees table. For each employee, we want to count the num‐
-- ber of employees with the same or higher salary ( ge_cnt ).

--- my answer solve = rows frame  --> not right with (dave and cindy) and (irene and henry) should be the same is 6
select id, name, salary,
count(*) over w as ge_cnt
from employees
window w as (
order by salary
rows between current row and UNBOUNDED FOLLOWING 
)
order by salary, ge_cnt;

id          sal     ge_cnt
11	Diane	70	    10
12	Bob	    78	    9
21	Emma	84	    8
22	Grace	90	    7
32	Dave	96	    5
31	Cindy	96	    6
33	Alice	100	    4
24	Irene	104	    2
23	Henry	104	    3
25	Frank	120	    1

-- thinking about groups frame order by salary (dave and cindy) and (irene and henry) will be same group 
-- to count other groups (current as the same salary and following group for greater salary )
--> right approach

select id, name, salary,
count(*) over w as ge_cnt
from employees
window w as (
order by salary
groups between current row and UNBOUNDED FOLLOWING 
)
order by salary, ge_cnt;


-- There is an employees table. For each employee, we want to know the next
-- higher salary ( next_salary ).
-- brainstorming:
--      order by salary (also partition by salary because this is group frame)
--  next higher salary will be first_value of the next group ??  --> groups between 1 following and 1 following ?
--> right approach and I am so smart :D 


select id, name, salary,
first_value(salary) over w as ge_cnt
from employees
window w as (
order by salary
groups between 1 FOLLOWING and 1 FOLLOWING 
)
order by salary, ge_cnt;