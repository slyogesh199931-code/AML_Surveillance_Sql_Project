CREATE TABLE occupation_master (
    occupation_id SERIAL PRIMARY KEY,
    occupation_name VARCHAR(50) NOT NULL
);

SELECT * FROM occupation_master;

INSERT INTO occupation_master (occupation_name) VALUES 
('Student'), 
('HNI Businessman'), 
('IT Professional'), 
('Unemployed Youth'), 
('Politically Exposed Person (PEP)'),
('Small Trader');                   

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    city VARCHAR(50),
    email VARCHAR(100),
    risk_category VARCHAR(10), -- LOW, MEDIUM, HIGH
    pep_status VARCHAR(5),     -- YES, NO
    occupation_id INT,
    FOREIGN KEY (occupation_id) REFERENCES occupation_master(occupation_id)
);

SELECT * FROM customers;


	INSERT INTO customers VALUES 
	(101, 'Ramesh Sharma', 21, 'Navi Mumbai', 'ramesh@dummy.com', 'LOW', 'NO', 1),
	(102, 'Amit Patel', 45, 'Mumbai', 'amit@dummy.com', 'HIGH', 'NO', 2),         
	(103, 'Suresh Kumar', 29, 'Bengaluru', 'suresh@dummy.com', 'MEDIUM', 'NO', 3),
	(104, 'Vijay Singh', 23, 'Pune', 'vijay@dummy.com', 'LOW', 'NO', 4),           
	(105, 'Vikram Adani', 52, 'New Delhi', 'vikram@dummy.com', 'HIGH', 'YES', 5),    
	(106, 'Deepak Verma', 34, 'Hyderabad', 'deepak@dummy.com', 'MEDIUM', 'NO', 6);



