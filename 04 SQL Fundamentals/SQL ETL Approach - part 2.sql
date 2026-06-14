-- Payment Staging
CREATE TABLE payments_staging (
	payment_id INT,
	loan_id INT, 
	payment_amount DECIMAL(10,2),
	payment_date DATE
)

-- Sample Data
INSERT INTO payments_staging (
    payment_id,
    loan_id,
    payment_amount,
    payment_date
)
VALUES

-- Loan 1 (duplicate ingestion example)
(1, 1, 25000.00, '2023-03-10'),
(1, 1, 25000.00, '2023-03-10'),  -- duplicate

-- Loan 2
(2, 2, 15000.00, '2023-07-15'),
(3, 2, 15000.00, '2023-08-15'),

-- Loan 3 (partial payments coming in late)
(4, 3, 20000.00, '2023-04-01'),
(5, 3, 10000.00, '2023-05-01'),

-- Loan 4 (high value business loan)
(6, 4, 300000.00, '2025-03-10'),
(7, 4, 300000.00, '2025-06-10'),
(7, 4, 300000.00, '2025-06-10'), -- duplicate

-- Loan 5
(8, 5, 500000.00, '2023-06-01'),
(9, 5, 500000.00, '2023-09-01'),

-- Loan 6
(10, 6, 75000.00, '2023-07-01'),
(11, 6, 75000.00, '2023-08-01'),

-- Loan 7
(12, 7, 60000.00, '2024-10-01'),
(13, 7, 60000.00, '2024-12-01'),
(13, 7, 60000.00, '2024-12-01'), -- duplicate

-- Loan 8
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

-- Loan 12 (partial + late ingestion)
(22, 12, 2000000.00, '2024-08-01'),
(23, 12, 2000000.00, '2024-10-01'),
(23, 12, 2000000.00, '2024-10-01'), -- duplicate

-- Loan 13
(24, 13, 3000000.00, '2023-11-01'),

-- Loan 14
(25, 14, 20000.00, '2024-01-10'),
(26, 14, 20000.00, '2024-02-10'),

-- Loan 15 (single payment only)
(27, 15, 30000.00, '2025-04-01'),
(27, 15, 30000.00, '2025-04-01'), -- duplicate ingestion

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


SELECT * FROM fact_payments;
SELECT count(*) FROM payments_staging


-- Inserting to main table (incremental loading method)
INSERT INTO fact_payments(payment_id,
    fact_loan_id,
    payment_amount,
    payment_date)
SELECT payment_id, loan_id, payment_amount, payment_date
FROM payments_staging
ON CONFLICT (payment_id) DO 
UPDATE
SET fact_loan_id = EXCLUDED.fact_loan_id,
payment_amount = EXCLUDED.payment_amount,
payment_date = EXCLUDED.payment_date;



