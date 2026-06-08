-- DDL - Data Definition Language CREATE, ALTER, DROP

create database company_db;

create table departments (
	dept_id INT PRIMARY KEY,
	dept_name VARCHAR(100) NOT NULL
);


create table employees (
	emp_id INT PRIMARY KEY, 
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100) UNIQUE,
	salary DECIMAL(10,2),
	dept_id INT,
	hire_date DATE,
	foreign key (dept_id) references departments(dept_id)
);


alter table employees
add is_active BOOLEAN;


alter table employees
add phone_number VARCHAR(20);


alter table employees
rename column phone_number to contact_number;



-- DML - Data Manipulation Language INSERT, UPDATE, DELETE

insert into departments (dept_id, dept_name)
values 
(1, 'Engineering'),
(2, 'Marketing'),
(3, 'Finance'),
(4, 'IT');


select * from departments


insert into employees
(emp_id, first_name, last_name, email, salary, dept_id, hire_date)
values
(101, 'Chris', 'Magno', 'chris@company.com', 80000, 1, '2023-01-10'),
(102, 'Ana', 'Santos', 'ana@company.com', 60000, 2, '2023-05-15'),
(103, 'John', 'Reyes', 'john@company.com', 75000, 1, '2022-09-01');



select * from employees;


update employees set salary = salary + 5000
where emp_id = 101;


update employees set is_active = true;


update employees set is_active = false
where emp_id = 103;


--delete from employees where emp_id = 103;



-- DQL - Data Query Language


select first_name, last_name, salary
from employees
where salary > 80000;



select * from employees
order by salary desc;


select dept_id, avg(salary) as avg_salary
from employees
group by dept_id;



-- joining
select 
	e.first_name,
	e.last_name,
	d.dept_name,
	e.salary
from employees e
join departments d
on e.dept_id = d.dept_id;


-- TCL - Transaction Control Languange

begin;

update employees e 
set salary = salary + 10000;

rollback;

commit;


-- views
create or replace view high_salary_employees as 
select e.first_name, e.last_name, e.salary, d.dept_name
from employees e
join departments d 
on d.dept_id = e.dept_id
where salary > 90000;


select * from high_salary_employees;