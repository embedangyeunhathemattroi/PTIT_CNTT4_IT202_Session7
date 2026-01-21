/* =====================================================
   THỰC HÀNH SQL – HỆ THỐNG BÁN HÀNG
   Sinh viên: Phạm Ngọc Linh
   ===================================================== */

-- =========================
-- PHẦN 1: TẠO CSDL & BẢNG
-- =========================

DROP DATABASE IF EXISTS phamngoclinh_hackathons;
CREATE DATABASE phamngoclinh_hackathons;
USE phamngoclinh_hackathons;

-- ---------- BẢNG CUSTOMER ----------
CREATE TABLE Customer (
    customer_id VARCHAR(5) PRIMARY KEY,
    customer_full_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE NOT NULL,
    customer_phone VARCHAR(15) UNIQUE NOT NULL,
    customer_address VARCHAR(255)
);

-- ---------- BẢNG PRODUCT ----------
CREATE TABLE Product (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    product_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- ---------- BẢNG ORDER ----------
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(5),
    product_id VARCHAR(5),
    order_date DATE NOT NULL,
    order_quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- ---------- BẢNG PAYMENT ----------
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- =========================
-- PHẦN 2: CHÈN DỮ LIỆU
-- =========================

INSERT INTO Customer VALUES
('C001','Nguyen Anh Tu','tu.nguyen@example.com','0987654321','Hanoi'),
('C002','Tran Thi Mai','mai.tran@example.com','0987654322','Ho Chi Minh'),
('C003','Le Minh Hoang','hoang.le@example.com','0987654323','Danang'),
('C004','Pham Hoang Nam','nam.pham@example.com','0987654324','Hue'),
('C005','Vu Minh Thu','thu.vu@example.com','0987654325','Hai Phong');

INSERT INTO Product VALUES
('P001','Laptop Dell','Electronics',15000.00,10),
('P002','iPhone 15','Electronics',20000.00,5),
('P003','T-Shirt','Clothing',200.00,50),
('P004','Running Shoes','Footwear',1500.00,20),
('P005','Table Lamp','Furniture',500.00,15);

INSERT INTO Orders VALUES
(1,'C001','P001','2025-06-01',1,15000.00),
(2,'C002','P003','2025-06-02',2,400.00),
(3,'C003','P002','2025-06-03',1,20000.00),
(4,'C001','P004','2025-06-03',1,1500.00),
(5,'C005','P001','2025-06-04',2,30000.00);

INSERT INTO Payment VALUES
(1,1,'2025-06-01','Banking','Paid'),
(2,2,'2025-06-02','Cash','Paid'),
(3,3,'2025-06-03','Credit Card','Paid'),
(4,4,'2025-06-04','Banking','Pending'),
(5,5,'2025-06-05','Credit Card','Paid');

-- =========================
-- PHẦN 3: TRUY VẤN CƠ BẢN
-- =========================

-- 3. Cập nhật số điện thoại khách hàng C001
UPDATE Customer
SET customer_phone = '0999888777'
WHERE customer_id = 'C001';

-- 4. Cập nhật kho và tăng giá 10% cho sản phẩm P003
UPDATE Product
SET stock_quantity = stock_quantity + 50,
    product_price = product_price * 1.1
WHERE product_id = 'P003';

-- 5. Xóa các Payment Pending + Banking
DELETE FROM Payment
WHERE payment_status = 'Pending'
  AND payment_method = 'Banking';

-- 6. Sản phẩm Electronics giá > 10000
SELECT product_id, product_name, product_price
FROM Product
WHERE category = 'Electronics'
  AND product_price > 10000;

-- 7. Khách hàng họ Nguyen
SELECT customer_full_name, customer_email, customer_address
FROM Customer
WHERE customer_full_name LIKE 'Nguyen%';

-- 8. Danh sách đơn hàng sắp xếp giảm dần theo total_amount
SELECT order_id, order_date, total_amount
FROM Orders
ORDER BY total_amount DESC;

-- 9. 3 thanh toán mới nhất
SELECT *
FROM Payment
ORDER BY payment_date DESC
LIMIT 3;

-- 10. Bỏ 2 bản ghi đầu, lấy 3 bản ghi tiếp theo
SELECT product_id, product_name
FROM Product
LIMIT 3 OFFSET 2;

-- =========================
-- PHẦN 4: TRUY VẤN NÂNG CAO
-- =========================

-- 11. Đơn hàng > 1000
SELECT o.order_id, c.customer_full_name, p.product_name, o.total_amount
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Product p ON o.product_id = p.product_id
WHERE o.total_amount > 1000;

-- 12. Tất cả sản phẩm + order_id (kể cả chưa bán)
SELECT p.product_id, p.product_name, o.order_id
FROM Product p
LEFT JOIN Orders o ON p.product_id = o.product_id;

-- 13. Tổng doanh thu theo loại sản phẩm
SELECT p.category,
       SUM(o.total_amount) AS Total_Revenue
FROM Orders o
JOIN Product p ON o.product_id = p.product_id
GROUP BY p.category;

-- 14. Khách hàng có từ 2 đơn trở lên
SELECT c.customer_full_name,
       COUNT(o.order_id) AS Order_Count
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_full_name
HAVING COUNT(o.order_id) >= 2;

-- 15. Đơn hàng có giá trị > trung bình
SELECT o.order_id, c.customer_full_name, o.total_amount AS rototal_amount
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
WHERE o.total_amount > (
    SELECT AVG(total_amount) FROM Orders
);

-- 16. Khách hàng từng mua Electronics
SELECT DISTINCT c.customer_full_name, c.customer_phone
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Product p ON o.product_id = p.product_id
WHERE p.category = 'Electronics';

-- 17. Tổng hợp đơn hàng + thanh toán
SELECT o.order_id,
       c.customer_full_name,
       p.product_name,
       pay.payment_method,
       pay.payment_status
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Product p ON o.product_id = p.product_id
JOIN Payment pay ON o.order_id = pay.order_id;
-- sync commit
