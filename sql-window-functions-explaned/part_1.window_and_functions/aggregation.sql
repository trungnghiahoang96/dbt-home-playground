-- Each department has a salary fund — money spent monthly on paying em‐
-- ployees’ salaries. Let’s see what percentage of this fund represents each em‐
-- ployee’s salary:
-- xem salary each employee take how many percents of departments budget
select
name, department, salary,
sum(salary) over  w as budget_by_dep,
round(salary*100.0 / sum(salary) over w) as percent_of_budget
from employees
window w as (partition by department)
order by department, salary;

                salary  budget   percent_of_budget
Diane	hr	    70	    148	    47.2972972972973
Bob	    hr	    78	    148	    52.7027027027027
Emma	it	    84	    502	    16.733067729083665
Grace	it	    90	    502	    17.92828685258964
Henry	it	    104	    502	    20.717131474103585
Irene	it	    104	    502	    20.717131474103585
Frank	it	    120	    502	    23.904382470119522
Cindy	sales	96	    292	    32.87671232876713
Dave	sales	96	    292	    32.87671232876713
Alice	sales	100	    292	    34.24657534246575


-- City salary fund
-- There is an employees table. For each employee, we want to know the ratio of
-- their salary to their home city salary fund (in %):

select
name, city, salary,
sum(salary) over  w as budget_by_dep,
round(salary*100.0 / sum(salary) over w) as percent_of_budget
from employees
window w as (partition by city)
order by city, salary;


-- Average department salary
-- There is an employees table. For each employee, we want to know the
-- following:
-- employee count in their department ( emp_cnt ),
-- average department salary ( sal_avg ),
-- deviation of their salary from the department average in % ( diff ).

select
name, department, salary,
count(*) over  w as num_cnt,
avg(salary) over  w as avg_by_dep,
ceiling(salary - avg(salary) over w) as diff_vs_avg
from employees
window w as (partition by department)
order by department, salary;