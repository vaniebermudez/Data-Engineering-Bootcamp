UPDATE employees SET is_active = FALSE
WHERE emp_id IN (101, 103, 117, 120, 128, 130, 149, 152);

select * from employees

-- subqueries
SELECT first_name, salary, dept_id
FROM employees
WHERE salary > (
	SELECT AVG(salary) FROM employees
);

-- case statements
CREATE VIEW salary_categorization AS
SELECT emp_id,
	first_name,
	last_name,
	salary,
CASE 
	WHEN salary >= 95000 THEN 'High Salary'
	WHEN salary >= 75999 THEN 'Medium Salary'
	ELSE 'Low Salary'
END AS salary_category
FROM employees;


select * from salary_categorization;



-- OVER() Window Functions

SELECT 
	first_name, 
	salary, 
	hire_date, 
	RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees


SELECT 
	first_name, 
	salary, 
	hire_date, 
	RANK() OVER (ORDER BY hire_date DESC) AS tenure_rank
FROM employees



SELECT
	first_name,
	salary,
	dept_id,
	RANK() OVER (ORDER BY salary DESC) as rank_gap, -- skips number in case of tie
	DENSE_RANK() OVER (ORDER BY salary DESC) as rank_dense  -- does not skip rank number
FROM employees;



-- SUM, Partition
SELECT 
	emp_id,
	first_name,
	dept_id,
	hire_date,
	salary,
	SUM(salary) OVER(PARTITION BY dept_id ORDER BY hire_date) as running_dept_cost
FROM employees;


-- LAG
SELECT 
	first_name,
	hire_date,
	salary,
	LAG(salary) OVER(ORDER BY hire_date) AS prev_hire_salary,
	salary - LAG(salary) OVER(ORDER BY hire_date) AS  salary_diff_from_prev
FROM employees;


SELECT 
	first_name,
	hire_date,
	dept_id,
	-- Get the date of the person hired just before 
	LAG(hire_date) OVER(PARTITION BY dept_id ORDER BY hire_date) AS prev_hire_date,
	-- Calculate the inverval (days) between hires
	hire_date - LAG(hire_date) OVER(PARTITION BY dept_id  ORDER BY hire_date) AS days_since_last_hire
FROM employees
ORDER BY hire_date;


-- CTE (Common Table Expressions)
WITH cte_active_employees AS (
	SELECT first_name, salary, dept_id, emp_id FROM employees
	WHERE is_active = TRUE
),
cte_salary_ranking AS (
	SELECT
		e.first_name,
		d.dept_name,
		e.salary,
		RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) as dept_rank
	FROM cte_active_employees e JOIN departments d ON e.dept_id = d.dept_id
)
-- SELECT * FROM cte_salary_ranking;
, cte_department_heads AS(
SELECT * FROM (
	SELECT 
		e.first_name,
		d.dept_name,
		e.salary,
		e.dept_id,
		e.emp_id,
		RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) AS dept_rank
	FROM cte_active_employees e JOIN departments d ON e.dept_id=d.dept_id
	) AS A
 WHERE dept_rank=1
)
-- SELECT * FROM cte_department_heads


UPDATE employees
SET manager_id = dh.emp_id
FROM cte_department_heads dh
WHERE employees.dept_id = dh.dept_id AND employees.emp_id != dh.emp_id



-- SELF JOIN
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee,
	CONCAT(m.first_name, ' ', m.last_name) AS manager,
	d.dept_name,
	e.salary
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
LEFT JOIN departments d on d.dept_id = e.dept_id


-- PROCEDURE (Stored Procedures)

CREATE OR REPLACE PROCEDURE public.increase_salary()
LANGUAGE 'plpgsql'
AS $$
BEGIN
	UPDATE employees
	SET salary = salary * 2.10;
END$$
;

call increase_salary();