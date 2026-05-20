-- 1. Wipe the slate clean
DROP TABLE IF EXISTS ipldata;

-- 2. Create the table
CREATE TABLE ipldata (
    match_id INTEGER,
    date DATE,
    match_type TEXT,
    event_name TEXT,
    innings INTEGER,
    batting_team TEXT,
    bowling_team TEXT,
    "over" INTEGER,
    ball INTEGER,
    ball_no NUMERIC,
    batter TEXT,
    bat_pos INTEGER,
    runs_batter INTEGER,
    balls_faced INTEGER,
    bowler TEXT,
    valid_ball INTEGER,
    runs_extras INTEGER,
    runs_total INTEGER,
    runs_bowler INTEGER,
    runs_not_boundary TEXT, -- Changed to TEXT to avoid import errors
    extra_type TEXT,
    non_striker TEXT,
    non_striker_pos INTEGER,
    wicket_kind TEXT,
    player_out TEXT,
    fielders TEXT,
    runs_target INTEGER,
    review_batter TEXT,
    team_reviewed TEXT,
    review_decision TEXT,
    umpire TEXT,
    umpires_call TEXT,
    player_of_match TEXT,
    match_won_by TEXT,
    win_outcome TEXT,
    toss_winner TEXT,
    toss_decision TEXT,
    venue TEXT,
    city TEXT,
    day INTEGER,
    month INTEGER,
    year INTEGER,
    season TEXT,
    gender TEXT,
    team_type TEXT,
    superover_winner TEXT,
    result_type TEXT,
    method TEXT,
    balls_per_over INTEGER,
    overs INTEGER,
    event_match_no TEXT,
    stage TEXT,
    match_number TEXT,
    team_runs INTEGER,
    team_balls INTEGER,
    team_wicket INTEGER,
    new_batter TEXT,
    batter_runs INTEGER,
    batter_balls INTEGER,
    bowler_wicket INTEGER,
    batting_partners TEXT,
    next_batter TEXT,
    striker_out TEXT
);

-- 3. Import the data
COPY ipldata (
    match_id, date, match_type, event_name, innings, batting_team, bowling_team, 
    "over", ball, ball_no, batter, bat_pos, runs_batter, balls_faced, bowler, 
    valid_ball, runs_extras, runs_total, runs_bowler, runs_not_boundary, 
    extra_type, non_striker, non_striker_pos, wicket_kind, player_out, 
    fielders, runs_target, review_batter, team_reviewed, review_decision, 
    umpire, umpires_call, player_of_match, match_won_by, win_outcome, 
    toss_winner, toss_decision, venue, city, day, month, year, season, 
    gender, team_type, superover_winner, result_type, method, 
    balls_per_over, overs, event_match_no, stage, match_number, 
    team_runs, team_balls, team_wicket, new_batter, batter_runs, 
    batter_balls, bowler_wicket, batting_partners, next_batter, striker_out
)
FROM 'C:/aditya(projects)/IPL.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');

-- 4. Check the results
SELECT * FROM ipldata;


-- how to fetch run details of batter
SELECT batter, SUM(runs_total) AS total_runs
FROM ipldata
GROUP BY batter
ORDER BY total_runs DESC;

-- distinct command
select distinct batter, batting_team , SUM(runs_total) AS total_runs
from ipldata
group by batting_team,batter
order by total_runs desc limit 10;

-- Alias

SELECT bowler,bowling_team,sum(bowler_wicket)as total_wickets
from ipldata
group by bowler ,bowling_team
order by total_wickets DESC   limit 10 ;

--WHERE
SELECT bowler,bowling_team,sum(bowler_wicket)as total_wickets
from ipldata
where bowling_team = 'Mumbai Indians'
group by bowler ,bowling_team
order by total_wickets DESC   limit 10 ;

select distinct batter, batting_team , SUM(runs_total) AS total_runs
from ipldata
where batting_team = 'Royal Challengers Bangalore'
group by batting_team,batter
order by total_runs desc limit 10;


select distinct batter, batting_team , SUM(runs_total) AS total_runs
from ipldata
where batting_team != 'Royal Challengers Bangalore'
group by batting_team,batter
order by total_runs desc limit 10;

select distinct batting_team, sum(team_runs) as total_Team_run from ipldata
group by batting_team
order by total_Team_run desc;

--IN
select distinct batter, batting_team , SUM(runs_total) AS total_runs
from ipldata
where batter in ('V Kohli','RG Sharma','SA Yadav')
group by batting_team,batter
order by total_runs desc limit 10;

--MIN
select distinct batter, batting_team , MIN(runs_total) AS Min_total_runs
from ipldata
where batting_team in ('Mumbai Indians','Mumbai Indian')
group by batting_team,batter
order by Min_total_runs ASC;

--MAX
select distinct batter, batting_team , MAX(runs_total) AS Max_total_runs
from ipldata
where batting_team in ('Mumbai Indians','Mumbai Indian')
group by batting_team,batter
order by Max_total_runs desc;


select distinct batter, batting_team , runs_total 
from ipldata
where batting_team in ('Mumbai Indians','Mumbai Indian')

order by runs_total desc;


-- subqueries in sql
/* Create the sales table in PostgreSQL */
CREATE TABLE sales (
  transaction_id INTEGER,
  customer_id INTEGER,
  product_name TEXT,
  sale_date DATE,
  sale_amount FLOAT
);

/* Inserting data to the sales table */
INSERT INTO sales (transaction_id, customer_id, product_name, sale_date, sale_amount)
VALUES
(1, 1, 'Product A', '2021-01-01', 10.00),
(2, 1, 'Product B', '2021-01-01', 20.00),
(3, 2, 'Product A', '2021-01-02', 15.00),
(4, 3, 'Product C', '2021-01-02', 30.00),
(5, 2, 'Product B', '2021-01-03', 25.00),
(6, 1, 'Product C', '2021-01-03', 15.00),
(7, 4, 'Product A', '2021-01-04', 10.00),
(8, 5, 'Product B', '2021-01-04', 20.00),
(9, 6, 'Product C', '2021-01-05', 25.00),
(10, 3, 'Product A', '2021-01-05', 30.00),
(11, 2, 'Product B', '2021-01-06', 15.00),
(12, 1, 'Product C', '2021-01-06', 20.00),
(13, 3, 'Product A', '2021-01-07', 10.00),
(14, 4, 'Product B', '2021-01-07', 20.00),
(15, 5, 'Product C', '2021-01-08', 25.00),
(16, 6, 'Product A', '2021-01-08', 30.00),
(17, 2, 'Product B', '2021-01-09', 15.00),
(18, 1, 'Product C', '2021-01-09', 20.00),
(19, 4, 'Product A', '2021-01-10', 10.00),
(20, 3, 'Product B', '2021-01-10', 25.00);

select * from sales
where sale_amount>=(select avg(sale_amount) as avg_sales from sales);


SELECT product_name,transaction_id
FROM sales
WHERE sale_amount = (SELECT MAX(sale_amount) FROM sales);

select * from sales
where sale_date in (select sale_date  from sales
WHERE sale_amount = (SELECT MAX(sale_amount) FROM sales) );


-- JOINS

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department_id INT
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);
-- Insert data into employees table
INSERT INTO employees (emp_id, emp_name, department_id) VALUES
(1, 'John', 1),
(2, 'Alice', 1),
(3, 'Bob', 2),
(4, 'Carol', NULL);

-- Insert data into departments table
INSERT INTO departments (department_id, department_name) VALUES
(1, 'Sales'),
(2, 'Marketing'),
(3, 'HR');


select * from employees;
select * from departments;

-- INNER JOIN

SELECT e.emp_name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

-- LEFT JOIN
SELECT e.emp_name, d.department_name
FROM employees e
left JOIN departments d
ON e.department_id = d.department_id;

-- RIGHT JOIN
SELECT e.emp_name, d.department_name
FROM employees e
right JOIN departments d
ON e.department_id = d.department_id;

-- FULL JOIN
SELECT e.emp_name, d.department_name
FROM employees e
full JOIN departments d
ON e.department_id = d.department_id;

--SELF JOIN
-- Step 1: Create the Employees table
CREATE TABLE Employees2 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

-- Step 2: Insert data into the Employees table
INSERT INTO Employees2 (emp_id, name, manager_id)
VALUES
(1, 'John', 3),
(2, 'Jane', 3),
(3, 'Bob', 4),
(4, 'Alice', NULL);

select e.name as employee_name,m.name as manager_name
from Employees2 e
inner join  Employees2 m
on e.emp_id=m.manager_id;

--CROSS JOIN

-- Step 1: Create the "colors" table
CREATE TABLE colors (
    color VARCHAR(50)
);

-- Step 2: Insert data into the "colors" table
INSERT INTO colors (color)
VALUES
('red'),
('blue'),
('green');

-- Step 3: Create the "sizes" table
CREATE TABLE sizes (
    size VARCHAR(10)
);

-- Step 4: Insert data into the "sizes" table
INSERT INTO sizes (size)
VALUES
('S'),
('M'),
('L');


SELECT colors.color, sizes.size
FROM colors
CROSS JOIN sizes;


-- Natural Join
-- Step 1: Create the "students" table
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

-- Step 2: Insert data into the "students" table
INSERT INTO students (id, name, age)
VALUES
(1, 'John', 18),
(2, 'Jane', 19),
(3, 'Bob', 20);

-- Step 3: Create the "grades" table
CREATE TABLE grades (
    id INT PRIMARY KEY,
    grade CHAR(1)
);

-- Step 4: Insert data into the "grades" table
INSERT INTO grades (id, grade)
VALUES
(1, 'A'),
(2, 'B'),
(3, 'C');

select * from students
natural join grades;

-- handling duplicate values

CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO customers (id, name, email, city) VALUES
(1, 'John Smith', 'john.smith@example.com', 'New York'),
(2, 'Jane Doe', 'jane.doe@example.com', 'London'),
(3, 'John Smith', 'john.smith@example.com', 'Los Angeles'),
(4, 'Sarah Johnson', 'sarah.johnson@example.com', 'New York'),
(5, 'Jane Doe', 'jane.doe@example.com', 'New York');


select name,email,count(*) from customers
group by name,email
having count(*)>1;

select distinct name from  customers;

SELECT name FROM customers
UNION
SELECT city FROM customers;
