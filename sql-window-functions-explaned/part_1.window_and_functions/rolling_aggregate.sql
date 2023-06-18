
-- To smooth out these spikes, we’ll use the “3-month average” 

select
year, month, expense,
round(avg(expense) over w) as roll_avg
from expenses
where year = 2020 and month <= 9
window w as (
order by year, month
rows between 1 preceding and 1 following
)
order by year, month;




-- Income moving average
-- There is an expenses table. We want to calculate the income moving average
-- for the previous and current months:

select
year, month, income,
round(avg(income) over w) as roll_avg
from expenses
where year = 2020 and month <= 9
window w as (
order by year, month
rows between 1 preceding and current row
)
order by year, month;


-- -- Cumulative total
-- t_ columns show cumulative values:
-- income ( t_income ),
-- expenses ( t_expense ),
-- profit ( t_profit ).

select
year, month, income, expense,
sum(income) over w as t_income,
sum(expense) over w as t_expense,
sum(income - expense) over w as t_profit
from expenses
where year = 2020 and month <= 9
window w as (
order by year, month
rows between UNBOUNDED preceding and current row
)
order by year, month;

-- answer - same result
select
year, month, income, expense,
sum(income) over w as t_income,
sum(expense) over w as t_expense,
sum(income) over w - sum(expense) over w as t_profit
from expenses
where year = 2020 and month = 9
window w as (
order by year, month
rows between unbounded preceding and current row
)
order by year, month;


-- Cumulative salary fund
-- We want to calculate the cumulative salary fund for each department:

select id, name, department, salary,
sum(salary) over w as total
from employees
window w as (partition by department order by salary, id)
order by department, salary, id;

-- answer - same results but explicit define row range for frame (instead default bahavior of partition with order by)
select
id, name, department, salary,
sum(salary) over w as total
from employees
window w as (
partition by department
order by salary, id
rows between unbounded preceding and current row
)
order by department, salary, id;


-- expenses
select
year, month, expense,
sum(expense) over w as total
from expenses
where year = 2020 and month = 9
window w as (
order by year, month
rows between unbounded preceding and current row
)
order by year, month;
