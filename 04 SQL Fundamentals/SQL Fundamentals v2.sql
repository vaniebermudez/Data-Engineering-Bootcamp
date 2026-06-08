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
-- (1, 'Engineering'),
-- (2, 'Marketing'),
-- (3, 'Finance'),
-- (4, 'IT'),
(5, 'Sales');



select * from departments


insert into employees
(emp_id, first_name, last_name, email, salary, dept_id, hire_date)
values
-- (101, 'Chris', 'Magno', 'chris@company.com', 80000, 1, '2023-01-10'),
-- (102, 'Ana', 'Santos', 'ana@company.com', 60000, 2, '2023-05-15'),
-- (103, 'John', 'Reyes', 'john@company.com', 75000, 1, '2022-09-01'),
(117, 'Melissa', 'Aquino', 'melissa.aquino@company.com', 46000, 3, '2026-01-19'),
(118, 'Charles', 'Bautista', 'charles.bautista@company.com', 71000, 1, '2024-07-27'),
(119, 'Stephanie', 'Villanueva', 'stephanie.villanueva@company.com', 64000, 2, '2023-10-09'),
(120, 'Matthew', 'Perez', 'matthew.perez@company.com', 39000, 3, '2025-08-04'),
(121, 'Nicole', 'Garcia', 'nicole.garcia@company.com', 105000, 5, '2020-11-15'),
(122, 'Anthony', 'Martinez', 'anthony.martinez@company.com', 76000, 1, '2023-02-28'),
(123, 'Samantha', 'Rodriguez', 'samantha.rodriguez@company.com', 59000, 2, '2024-12-03'),
(124, 'Daniel', 'Lopez', 'daniel.lopez@company.com', 85000, 4, '2022-06-16'),
(125, 'Rachel', 'Hernandez', 'rachel.hernandez@company.com', 48000, 3, '2025-03-21'),
(126, 'Paul', 'Gonzales', 'paul.gonzales@company.com', 76000, 1, '2024-01-08'),
(127, 'Lauren', 'Wilson', 'lauren.wilson@company.com', 63000, 2, '2023-05-29'),
(128, 'Kevin', 'Anderson', 'kevin.anderson@company.com', 41000, 3, '2026-04-12'),
(129, 'Megan', 'Thomas', 'megan.thomas@company.com', 92000, 5, '2021-09-07'),
(130, 'Brian', 'Taylor', 'brian.taylor@company.com', 74000, 1, '2023-08-22'),
(131, 'Kayla', 'Moore', 'kayla.moore@company.com', 56000, 2, '2025-02-15'),
(143, 'Michelle', 'Robinson', 'michelle.robinson@company.com', 60000, 2, '2023-03-24'),
(144, 'Gary', 'Walker', 'gary.walker@company.com', 40000, 3, '2025-10-06'),
(145, 'Rebecca', 'Young', 'rebecca.young@company.com', 94000, 5, '2021-07-13'),
(146, 'Nicholas', 'Allen', 'nicholas.allen@company.com', 75000, 1, '2023-07-08'),
(147, 'Laura', 'King', 'laura.king@company.com', 54000, 2, '2024-05-01'),
(148, 'Eric', 'Wright', 'eric.wright@company.com', 87000, 4, '2022-02-19'),
(149, 'Kelly', 'Scott', 'kelly.scott@company.com', 44000, 3, '2025-12-29'),
(150, 'Stephen', 'Torres', 'stephen.torres@company.com', 78000, 1, '2024-10-23'),
(151, 'Andrea', 'Nguyen', 'andrea.nguyen@company.com', 65000, 2, '2023-01-16'),
(152, 'Larry', 'Hill', 'larry.hill@company.com', 38000, 3, '2026-05-11'),
(153, 'Christina', 'Flores', 'christina.flores@company.com', 91000, 5, '2021-08-26'),
(154, 'Justin', 'Green', 'justin.green@company.com', 73000, 1, '2024-04-03');


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
where salary >= 90000;


select * from high_salary_employees;