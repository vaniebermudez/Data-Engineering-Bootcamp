-- QuickCash a fintech loan company

-- 1. Customer Applies for loan
-- 2. Loan gets approved
-- 3. Loan is released to customer
-- 4. Customer pays loan across multiple days
-- 5. Analytics team monitors payments and risk



CREATE DATABASE quickcash_dw


-- Data Modeling (Foundation of Analytics)

-- Dimension Tables -> descriptive information (ex. customer profile)

-- DDL
CREATE TABLE dim_customers(
	dim_customer_id SERIAL PRIMARY KEY,
	customer_id INT,
	customer_name VARCHAR(100),
	email VARCHAR(100),
	city VARCHAR(50),
	signup_date DATE,
	effective_start_date DATE,
	effective_end_date DATE,
	is_latest_status BOOLEAN
)
-- DML
INSERT INTO dim_customers (
    customer_id,
    customer_name,
    email,
    city,
    signup_date,
    effective_start_date,
    effective_end_date,
    is_latest_status
)
VALUES

-- Customer 101
(101, 'John Smith', 'john.smith@email.com', 'Manila',
 '2023-01-15', '2023-01-15', '2024-03-10', FALSE),
(101, 'John Smith', 'john.smith@email.com', 'Quezon City',
 '2023-01-15', '2024-03-11', NULL, TRUE),

-- Customer 102
(102, 'Maria Santos', 'maria.santos@email.com', 'Cebu City',
 '2023-02-20', '2023-02-20', NULL, TRUE),

-- Customer 103
(103, 'David Cruz', 'david.cruz@email.com', 'Davao City',
 '2023-03-05', '2023-03-05', '2025-01-31', FALSE),
(103, 'David Cruz', 'david.cruz@email.com', 'Tagum City',
 '2023-03-05', '2025-02-01', NULL, TRUE),

-- Customer 104
(104, 'Ana Reyes', 'ana.reyes@email.com', 'Baguio City',
 '2023-04-18', '2023-04-18', NULL, TRUE),

-- Customer 105
(105, 'Mark Villanueva', 'mark.v@email.com', 'Makati City',
 '2023-05-12', '2023-05-12', '2024-08-15', FALSE),
(105, 'Mark Villanueva', 'mark.v@email.com', 'Pasig City',
 '2023-05-12', '2024-08-16', NULL, TRUE),

-- Customer 106
(106, 'Sophia Garcia', 'sophia.g@email.com', 'Iloilo City',
 '2023-06-30', '2023-06-30', NULL, TRUE),

-- Customer 107
(107, 'Michael Tan', 'michael.tan@email.com', 'Cagayan de Oro',
 '2023-08-11', '2023-08-11', NULL, TRUE),

-- Customer 108
(108, 'Kevin Lim', 'kevin.lim@email.com', 'Pasay City',
 '2023-09-02', '2023-09-02', NULL, TRUE),

-- Customer 109
(109, 'Patricia Gomez', 'patricia.g@email.com', 'Manila',
 '2023-09-15', '2023-09-15', '2024-06-30', FALSE),
(109, 'Patricia Gomez', 'patricia.g@email.com', 'Makati City',
 '2023-09-15', '2024-07-01', NULL, TRUE),

-- Customer 110
(110, 'James Uy', 'james.uy@email.com', 'Bacolod City',
 '2023-10-05', '2023-10-05', NULL, TRUE),

-- Customer 111
(111, 'Angela Co', 'angela.co@email.com', 'Quezon City',
 '2023-11-10', '2023-11-10', '2025-03-14', FALSE),
(111, 'Angela Co', 'angela.co@email.com', 'Antipolo City',
 '2023-11-10', '2025-03-15', NULL, TRUE),

-- Customer 112
(112, 'Joshua Lee', 'joshua.lee@email.com', 'Taguig City',
 '2023-12-01', '2023-12-01', NULL, TRUE),

-- Customer 113
(113, 'Karen Flores', 'karen.f@email.com', 'Cebu City',
 '2024-01-08', '2024-01-08', NULL, TRUE),

-- Customer 114
(114, 'Ryan Mendoza', 'ryan.m@email.com', 'Dumaguete City',
 '2024-01-20', '2024-01-20', '2024-11-20', FALSE),
(114, 'Ryan Mendoza', 'ryan.m@email.com', 'Cebu City',
 '2024-01-20', '2024-11-21', NULL, TRUE),

-- Customer 115
(115, 'Nicole Ramos', 'nicole.r@email.com', 'San Pablo City',
 '2024-02-02', '2024-02-02', NULL, TRUE),

-- Customer 116
(116, 'Christian dela Cruz', 'christian.dc@email.com', 'Calamba City',
 '2024-02-15', '2024-02-15', '2025-01-09', FALSE),
(116, 'Christian dela Cruz', 'christian.dc@email.com', 'Santa Rosa City',
 '2024-02-15', '2025-01-10', NULL, TRUE),

-- Customer 117
(117, 'Grace Tan', 'grace.tan@email.com', 'Taguig City',
 '2024-03-01', '2024-03-01', NULL, TRUE),

-- Customer 118
(118, 'Paul Fernandez', 'paul.f@email.com', 'General Santos City',
 '2024-03-15', '2024-03-15', NULL, TRUE),

-- Customer 119
(119, 'Liza Navarro', 'liza.n@email.com', 'Batangas City',
 '2024-04-01', '2024-04-01', '2025-05-31', FALSE),
(119, 'Liza Navarro', 'liza.n@email.com', 'Lipa City',
 '2024-04-01', '2025-06-01', NULL, TRUE),

-- Customer 120
(120, 'Edward Chua', 'edward.chua@email.com', 'Manila',
 '2024-04-12', '2024-04-12', '2024-12-31', FALSE),
(120, 'Edward Chua', 'edward.chua@email.com', 'Quezon City',
 '2024-04-12', '2025-01-01', '2025-05-15', FALSE),
(120, 'Edward Chua', 'edward.chua@email.com', 'Makati City',
 '2024-04-12', '2025-05-16', NULL, TRUE);

--DDL
CREATE TABLE dim_loan_products(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(50),
	interest_rate DECIMAL(5,2),
	max_amount DECIMAL(12,2)
)
-- ALTER TABLE dim_loan_products
-- RENAME COLUMN dim_loan_product_id to product_id
--DML
INSERT INTO dim_loan_products (
    product_id,
    product_name,
    interest_rate,
    max_amount
)
VALUES
(1, 'Personal Loan Basic', 10.50, 100000.00),
(2, 'Personal Loan Plus', 8.75, 300000.00),
(3, 'Salary Loan', 6.50, 50000.00),
(4, 'Emergency Loan', 12.00, 25000.00),
(5, 'Auto Loan Standard', 5.25, 1500000.00),
(6, 'Auto Loan Premium', 4.50, 3000000.00),
(7, 'Motorcycle Loan', 7.25, 250000.00),
(8, 'Home Loan Starter', 4.75, 3000000.00),
(9, 'Home Loan Premium', 3.95, 10000000.00),
(10, 'Housing Construction Loan', 5.50, 5000000.00),
(11, 'SME Business Loan', 8.00, 2000000.00),
(12, 'Business Expansion Loan', 7.25, 5000000.00),
(13, 'Agricultural Loan', 4.00, 1000000.00),
(14, 'Education Loan', 5.75, 500000.00),
(15, 'Medical Assistance Loan', 6.25, 300000.00),
(16, 'OFW Loan', 7.50, 1000000.00),
(17, 'Credit Builder Loan', 11.00, 50000.00),
(18, 'Green Energy Loan', 4.25, 2000000.00),
(19, 'Microfinance Loan', 9.50, 100000.00),
(20, 'Startup Business Loan', 8.50, 3000000.00);

-- Fact tables -> transactions (ex. loan)
--DDL
CREATE TABLE fact_loans(
	fact_loan_id INT PRIMARY KEY,
	customer_id INT,
	product_id INT,
	loan_amount DECIMAL(12,2),
	loan_status VARCHAR(20),
	loan_start_date DATE
)
--DML
INSERT INTO fact_loans (
    fact_loan_id,
    customer_id,
    product_id,
    loan_amount,
    loan_status,
    loan_start_date
)
VALUES

-- Customer 101 (multiple loans)
(1, 101, 1, 50000.00, 'Closed', '2023-02-10'),
(2, 101, 3, 30000.00, 'Closed', '2023-06-15'),

-- Customer 102
(3, 102, 14, 200000.00, 'Active', '2023-03-01'),

-- Customer 103
(4, 103, 5, 1200000.00, 'Active', '2025-02-10'),

-- Customer 104
(5, 104, 8, 2500000.00, 'Active', '2023-05-01'),

-- Customer 105 (two city life stages already in dim table)
(6, 105, 2, 150000.00, 'Closed', '2023-06-01'),
(7, 105, 7, 120000.00, 'Active', '2024-09-01'),

-- Customer 106
(8, 106, 11, 1800000.00, 'Active', '2023-07-10'),

-- Customer 107
(9, 107, 3, 40000.00, 'Closed', '2023-09-01'),

-- Customer 108
(10, 108, 1, 80000.00, 'Active', '2023-10-01'),

-- Customer 109
(11, 109, 2, 250000.00, 'Closed', '2023-10-20'),
(12, 109, 12, 4000000.00, 'Active', '2024-07-05'),

-- Customer 110
(13, 110, 9, 8500000.00, 'Active', '2023-10-15'),

-- Customer 111
(14, 111, 1, 60000.00, 'Closed', '2023-12-01'),
(15, 111, 19, 70000.00, 'Active', '2025-03-20'),

-- Customer 112
(16, 112, 16, 500000.00, 'Active', '2024-01-10'),

-- Customer 113
(17, 113, 14, 300000.00, 'Active', '2024-01-15'),

-- Customer 114
(18, 114, 5, 2000000.00, 'Closed', '2024-02-01'),
(19, 114, 6, 2800000.00, 'Active', '2024-11-25'),

-- Customer 115
(20, 115, 15, 150000.00, 'Active', '2024-02-10'),

-- Customer 116
(21, 116, 10, 3500000.00, 'Closed', '2024-03-01'),
(22, 116, 10, 4200000.00, 'Active', '2025-01-15'),

-- Customer 117
(23, 117, 7, 180000.00, 'Active', '2024-03-10'),

-- Customer 118
(24, 118, 11, 2000000.00, 'Active', '2024-03-20'),

-- Customer 119
(25, 119, 8, 2800000.00, 'Closed', '2024-04-10'),
(26, 119, 9, 9500000.00, 'Active', '2025-06-10'),

-- Customer 120 (multiple loan lifecycle changes in dim table)
(27, 120, 1, 50000.00, 'Closed', '2024-05-01'),
(28, 120, 2, 200000.00, 'Closed', '2025-01-10'),
(29, 120, 12, 4500000.00, 'Active', '2025-05-20');

--DDL
CREATE TABLE fact_payments(
	payment_id INT PRIMARY KEY,
	fact_loan_id INT,
	payment_amount DECIMAL(10,2),
	payment_date DATE
)
--DML
INSERT INTO fact_payments (
    payment_id,
    fact_loan_id,
    payment_amount,
    payment_date
)
VALUES

-- Loan 1 (fully paid)
(1, 1, 25000.00, '2023-03-10'),
(2, 1, 25000.00, '2023-04-10'),

-- Loan 2 (fully paid)
(3, 2, 15000.00, '2023-07-15'),
(4, 2, 15000.00, '2023-08-15'),

-- Loan 3 (active partial)
(5, 3, 50000.00, '2023-04-01'),

-- Loan 4 (active partial)
(6, 4, 300000.00, '2025-03-10'),
(7, 4, 300000.00, '2025-06-10'),

-- Loan 5 (active home loan partial)
(8, 5, 500000.00, '2023-06-01'),
(9, 5, 500000.00, '2023-09-01'),

-- Loan 6 (auto loan closed)
(10, 6, 75000.00, '2023-07-01'),
(11, 6, 75000.00, '2023-08-01'),

-- Loan 7
(12, 7, 60000.00, '2024-10-01'),
(13, 7, 60000.00, '2024-12-01'),

-- Loan 8 (business loan)
(14, 8, 600000.00, '2023-08-10'),
(15, 8, 600000.00, '2023-10-10'),

-- Loan 9
(16, 9, 20000.00, '2023-10-01'),
(17, 9, 20000.00, '2023-11-01'),

-- Loan 10
(18, 10, 40000.00, '2023-11-01'),
(19, 10, 40000.00, '2023-12-01'),

-- Loan 11
(20, 11, 125000.00, '2023-11-20'),
(21, 11, 125000.00, '2023-12-20'),

-- Loan 12 (large business loan)
(22, 12, 2000000.00, '2024-08-01'),
(23, 12, 2000000.00, '2024-10-01'),

-- Loan 13 (home loan)
(24, 13, 3000000.00, '2023-11-01'),

-- Loan 14
(25, 14, 20000.00, '2024-01-10'),
(26, 14, 20000.00, '2024-02-10'),

-- Loan 15
(27, 15, 30000.00, '2025-04-01'),

-- Loan 16
(28, 16, 250000.00, '2024-02-01'),

-- Loan 17
(29, 17, 150000.00, '2024-02-15'),

-- Loan 18
(30, 18, 1000000.00, '2024-03-01'),

-- Loan 19
(31, 19, 1000000.00, '2024-12-01'),

-- Loan 20
(32, 20, 150000.00, '2024-02-20'),

-- Loan 21
(33, 21, 1750000.00, '2024-05-01'),

-- Loan 22
(34, 22, 2100000.00, '2025-02-01'),

-- Loan 23
(35, 23, 90000.00, '2024-04-01'),

-- Loan 24
(36, 24, 1000000.00, '2024-05-01'),

-- Loan 25
(37, 25, 1400000.00, '2024-06-01'),

-- Loan 26
(38, 26, 4500000.00, '2025-06-15'),

-- Loan 27
(39, 27, 25000.00, '2024-06-01'),

-- Loan 28
(40, 28, 100000.00, '2025-03-01'),

-- Loan 29
(41, 29, 2250000.00, '2025-06-01');




-- How much has each borrower already paid?
SELECT fact_loan_id,
	payment_date,
	payment_amount,
	SUM(payment_amount) OVER (PARTITION BY fact_loan_id ORDER BY payment_date, payment_id) as running_total
FROM fact_payments
-- WHERE fact_loan_id = 12


-- Updating fact loans with the correct status based on paid amount
WITH payment_summary AS (
-- Get total payments per loan
	SELECT
		fact_loan_id,
		SUM(payment_amount) AS total_paid
	FROM fact_payments
	GROUP BY fact_loan_id
)
UPDATE fact_loans f
SET loan_status = CASE
					WHEN ps.total_paid >= f.loan_amount then 'Fully Paid'
					WHEN ps.total_paid >0 AND ps.total_paid < f.loan_amount THEN 'Active'
					ELSE 'Pending'
				END
FROM payment_summary ps
WHERE F.fact_loan_id = ps.fact_loan_id


SELECT * FROM fact_loans 
-- WHERE fact_loan_id = 12

-- SCD Type 2. Not deleting old records, updating new record by adding another row
-- Updating Customer Info
UPDATE dim_customers
	SET effective_end_date = CURRENT_DATE,
	is_latest_status = FALSE
	WHERE customer_id = 101
	AND is_latest_status = TRUE;
INSERT INTO dim_customers (
    customer_id,
    customer_name,
    email,
    city,
    signup_date,
    effective_start_date,
    effective_end_date,
    is_latest_status
)
VALUES (101, 'John Smith', 'john.smith@email.com', 'San Fernando', '2023-01-15', CURRENT_DATE, Null, TRUE)


SELECT * FROM dim_customers WHERE customer_id=101
