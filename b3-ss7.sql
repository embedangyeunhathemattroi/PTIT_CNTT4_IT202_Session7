CREATE DATABASE b3_ss7;
USE b3_ss7;

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 500000),
(2, '2025-01-02', 300000),
(3, '2025-01-03', 1200000),
(4, '2025-01-04', 450000),
(5, '2025-01-05', 900000);

SELECT *FROM orders
WHERE total_amount > ( SELECT AVG(total_amount) FROM orders
);
-- sync commit
