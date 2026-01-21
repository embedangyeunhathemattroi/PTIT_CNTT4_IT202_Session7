CREATE DATABASE b2_ss7;
USE  b2_ss7;

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO products (name, price) VALUES
('Laptop', 15000000),
('Chuột', 200000),
('Bàn phím', 500000),
('Tai nghe', 800000),
('Màn hình', 3000000),
('USB', 150000),
('Ổ cứng', 2500000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(2, 4, 1),
(3, 1, 1),
(3, 5, 2),
(4, 7, 1);

SELECT *
FROM products
WHERE id IN (SELECT DISTINCT product_id FROM order_items
);
-- sync commit
