DROP TABLE IF EXISTS transactions;
DROP DATABASE IF EXISTS transactions;
TRUNCATE TABLE transactions;


CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(10), -- DEPOSIT, WITHDRAWAL
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP,
    status VARCHAR(10),           -- SUCCESS, FAILED
    channel VARCHAR(10),          -- UPI, IMPS, ATM, RTGS
    FOREIGN KEY (account_id) REFERENCES customers(customer_id)
);


SELECT * FROM transactions;



INSERT INTO transactions VALUES
('TXN001', 101, 'DEPOSIT', 9500.00, '2026-06-25 09:00:00', 'SUCCESS', 'UPI'),
('TXN002', 101, 'DEPOSIT', 9800.00, '2026-06-25 11:30:00', 'SUCCESS', 'UPI'),
('TXN003', 101, 'DEPOSIT', 9200.00, '2026-06-25 14:15:00', 'SUCCESS', 'UPI'),
('TXN004', 101, 'DEPOSIT', 9600.00, '2026-06-25 16:00:00', 'SUCCESS', 'UPI'),

('TXN005', 104, 'DEPOSIT', 45000.00, '2026-06-25 10:00:00', 'SUCCESS', 'IMPS'),
('TXN006', 104, 'WITHDRAWAL', 44900.00, '2026-06-25 10:05:00', 'SUCCESS', 'UPI'),

('TXN007', 105, 'DEPOSIT', 450000.00, '2026-06-25 12:00:00', 'SUCCESS', 'RTGS'),

-- (Non-Suspicious Triggers)

('TXN008', 102, 'DEPOSIT', 150000.00, '2026-06-25 12:30:00', 'SUCCESS', 'IMPS'),
('TXN009', 103, 'WITHDRAWAL', 5000.00, '2026-06-25 13:00:00', 'SUCCESS', 'ATM'),
('TXN010', 106, 'DEPOSIT', 25000.00, '2026-06-25 15:00:00', 'SUCCESS', 'UPI');



-- Structuring / Smurfing Anomaly Alert
SELECT 
    c.customer_id,
    c.name,
    om.occupation_name AS profile_type,
    c.city,
    c.risk_category,
    COUNT(t.transaction_id) AS total_alerts_count,
    SUM(t.amount) AS total_monitored_volume
FROM 
    transactions t
INNER JOIN 
    customers c ON t.account_id = c.customer_id
INNER JOIN 
    occupation_master om ON c.occupation_id = om.occupation_id
WHERE 
    t.transaction_type = 'DEPOSIT'
    AND t.status = 'SUCCESS'
    AND t.amount BETWEEN 9000 AND 9999
GROUP BY 
    c.customer_id, 
    c.name, 
    om.occupation_name, 
    c.city, 
    c.risk_category
HAVING 
    COUNT(t.transaction_id) >= 3;


-- Full Transaction Ledger Audit
SELECT 
    account_id,
    SUM(CASE WHEN transaction_type = 'DEPOSIT' AND status = 'SUCCESS' THEN amount ELSE 0 END) AS total_money_in,
    SUM(CASE WHEN transaction_type = 'WITHDRAWAL' AND status = 'SUCCESS' THEN amount ELSE 0 END) AS total_money_out,
    (SUM(CASE WHEN transaction_type = 'DEPOSIT' AND status = 'SUCCESS' THEN amount ELSE 0 END) - 
     SUM(CASE WHEN transaction_type = 'WITHDRAWAL' AND status = 'SUCCESS' THEN amount ELSE 0 END)) AS remaining_balance
FROM 
    transactions
WHERE 
    account_id = 101
GROUP BY 
    account_id;


-- Channel Wise Volume
SELECT 
    channel,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount) AS total_volume
FROM 
    transactions
WHERE 
    account_id = 101
GROUP BY 
    channel
ORDER BY 
    total_volume DESC;


-- Velocity Anomaly
SELECT 
    account_id,
    SUM(CASE WHEN transaction_type = 'DEPOSIT' THEN amount ELSE 0 END) AS total_in,
    SUM(CASE WHEN transaction_type = 'WITHDRAWAL' THEN amount ELSE 0 END) AS total_out,
    ABS(SUM(CASE WHEN transaction_type = 'DEPOSIT' THEN amount ELSE 0 END) - 
        SUM(CASE WHEN transaction_type = 'WITHDRAWAL' THEN amount ELSE 0 END)) AS net_difference
FROM 
    transactions
WHERE 
    status = 'SUCCESS'
GROUP BY 
    account_id
HAVING 
    ABS(SUM(CASE WHEN transaction_type = 'DEPOSIT' THEN amount ELSE 0 END) - 
        SUM(CASE WHEN transaction_type = 'WITHDRAWAL' THEN amount ELSE 0 END)) < 500
    AND SUM(CASE WHEN transaction_type = 'DEPOSIT' THEN amount ELSE 0 END) > 20000;


-- High-Risk PEP Alerts
SELECT 
    c.customer_id, c.name, om.occupation_name, t.amount, t.channel
FROM 
    transactions t
INNER JOIN 
    customers c ON t.account_id = c.customer_id
INNER JOIN 
    occupation_master om ON c.occupation_id = om.occupation_id
WHERE 
    c.pep_status = 'YES' 
    AND t.amount >= 200000.00 
    AND t.status = 'SUCCESS';


