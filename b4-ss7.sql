CREATE DATABASE b4_ss7;
USE b4_ss7;

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO customers (name, email) VALUES
('Nguyen Van A', 'a@gmail.com'),
('Tran Thi B', 'b@gmail.com'),
('Le Van C', 'c@gmail.com'),
('Pham Thi D', 'd@gmail.com'),
('Hoang Van E', 'e@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 500000),
(1, '2025-01-05', 300000),
(2, '2025-01-03', 700000),
(3, '2025-01-04', 250000),
(5, '2025-01-07', 450000);

SELECT id, name,email,
    (SELECT COUNT(id)
        FROM orders
        WHERE customer_id = customers.id
    ) AS total_orders
FROM customers;
-- sync commit
