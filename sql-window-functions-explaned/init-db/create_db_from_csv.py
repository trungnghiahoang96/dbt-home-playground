import duckdb

con = duckdb.connect("employee.duckdb")


con.sql(
    """
CREATE TABLE IF NOT EXISTS employees (
    id integer primary key,
    name varchar(50),
    city varchar(50),
    department varchar(50),
    salary integer
); 
COPY employees FROM 'employees.csv' (AUTO_DETECT TRUE);
"""
)


con.sql(
    """
CREATE TABLE IF NOT EXISTS expenses (
    year integer,
    month integer,
    income integer,
    expense integer
);
COPY expenses FROM 'expenses.csv' (AUTO_DETECT TRUE);
"""
)

con.close()
