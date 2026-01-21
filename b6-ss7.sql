CREATE DATABASE b6_ss7;
USE b6_ss7;

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
(3, '2025-01-10', 900000),
(4, '2025-01-07', 450000),
(5, '2025-01-09', 1200000);

SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_per_customer)
        FROM (
            SELECT SUM(total_amount) AS total_per_customer
            FROM orders
            GROUP BY customer_id
        ) AS t
    )
);

-- 1 .sdung DDL tao luoc do CSDL ( khoa chinh ngoai, rang buoc, not null, unique , default, check)
-- them - sua- xoa cot
-- => tao rang buoc sau khi tao bang( hoi roi ra sau khi tao bang)
-- 2: Sdung DML thuc hien : them , sua xóa du lieu(insert , update, delete)
--  3 : thuc hien cac truy van khi sdung DML:
-- a, truy van co ban, hien thi thong tin sv , gtinh , nam nu, ngay sinh, hien cua lop hoc
-- sdung join, ...
-- b , truy van nang cao
-- sdung join , truy van long( left join = left outer join ,right join = right outer join , full join, inner join- join 0)
-- sdung truy van long
-- sdung sum count max min,avg trên nhom du lieu
--  co dkien nhom
-- co sap xep
-- sync commit
