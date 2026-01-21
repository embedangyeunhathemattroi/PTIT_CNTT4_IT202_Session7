create database PhamNgocLinh_de9s;
use PhamNgocLinh_de9s;

create table shippers (
    shipper_id int primary key,
    full_name varchar(100) not null,
    phone varchar(15) unique,
    license_type varchar(20) not null,
    rating decimal(3,1) default 5.0 check (rating between 0 and 5)
);


create table vehicle_details (
    vehicle_id int primary key,
    shipper_id int,
    plate_number varchar(20) unique,
    vehicle_type enum('Tải','Xe máy','Container'),
    max_payload decimal(10,2) check (max_payload > 0),
    foreign key (shipper_id) references shippers(shipper_id)
);

create table shipments (
    shipment_id int primary key,
    product_name varchar(255),
    actual_weight decimal(10,2) check (actual_weight > 0),
    product_value decimal(15,2),
    status varchar(30)
);

-- ---------- table: delivery_orders ----------
create table delivery_orders (
    order_id int primary key,
    shipment_id int,
    shipper_id int,
    assigned_time datetime default current_timestamp,
    shipping_fee decimal(15,2),
    order_status varchar(30),
    foreign key (shipment_id) references shipments(shipment_id),
    foreign key (shipper_id) references shippers(shipper_id)
);

create table delivery_log (
    log_id int primary key,
    order_id int,
    current_location varchar(255),
    log_time datetime,
    note varchar(255),
    foreign key (order_id) references delivery_orders(order_id)
);


insert into shippers values
(1,'Nguyen Van An','0901234567','C',4.8),
(2,'Tran Thi Binh','0912345678','A2',5.0),
(3,'Le Hoang Nam','0983456789','FC',4.2),
(4,'Pham Minh Duc','0354567890','B2',4.9),
(5,'Hoang Quoc Viet','0775678901','C',4.7);

insert into vehicle_details values
(101,1,'29C-123.45','Tải',3500),
(102,2,'59A-888.88','Xe máy',500),
(103,3,'15R-999.99','Container',32000),
(104,4,'30F-111.22','Tải',1500),
(105,5,'43C-444.55','Tải',5000);

insert into shipments values
(5001,'Smart TV Samsung 55 inch',25.5,15000000,'In Transit'),
(5002,'Laptop Dell XPS',2.0,35000000,'Delivered'),
(5003,'Máy nén khí công nghiệp',450,120000000,'In Transit'),
(5004,'Thùng trái cây nhập khẩu',15,2500000,'Returned'),
(5005,'Máy giặt LG Inverter',70,9500000,'In Transit');

insert into delivery_orders values
(9001,5001,1,'2024-05-20 08:00:00',2000000,'Processing'),
(9002,5002,2,'2024-05-20 09:30:00',3500000,'Finished'),
(9003,5003,3,'2024-05-20 10:15:00',2500000,'Processing'),
(9004,5004,5,'2024-05-21 07:00:00',1500000,'Finished'),
(9005,5005,4,'2024-05-21 08:45:00',2500000,'Pending');

insert into delivery_log values
(1,9001,'Kho tổng (Hà Nội)','2021-05-15 08:15:00','Rời kho'),
(2,9001,'Trạm thu phí Phủ Lý','2021-05-17 10:00:00','Đang giao'),
(3,9002,'Quận 1, TP.HCM','2024-05-19 10:30:00','Đã đến điểm đích'),
(4,9003,'Cảng Hải Phòng','2024-05-20 11:00:00','Rời kho'),
(5,9004,'Kho hoàn hàng (Đà Nẵng)','2024-05-21 14:00:00','Đã nhập kho trả hàng');


update delivery_orders d
join shipments s on d.shipment_id = s.shipment_id
set d.shipping_fee = d.shipping_fee * 1.1
where d.order_status = 'Finished'
and s.actual_weight > 100;

delete from delivery_log
where log_time < '2024-05-17';


select plate_number, vehicle_type, max_payload
from vehicle_details
where max_payload > 5000
or (vehicle_type = 'Container' and max_payload < 2000);

select full_name, phone
from shippers
where rating between 4.5 and 5.0
and phone like '090%';

select *
from shipments
order by product_value desc
limit 2 offset 2;

select s.full_name, sh.shipment_id, sh.product_name, d.shipping_fee, d.assigned_time
from delivery_orders d
join shippers s on d.shipper_id = s.shipper_id
join shipments sh on d.shipment_id = sh.shipment_id;

select s.full_name, sum(d.shipping_fee) total_fee
from delivery_orders d
join shippers s on d.shipper_id = s.shipper_id
group by s.shipper_id
having total_fee > 3000000;

select *from shippers where rating = (select max(rating) from shippers);

create index idx_shipment_status_value on shipments(status, product_value);

create view vw_driver_performance as
select s.full_name,
       count(d.order_id) total_orders,
       sum(d.shipping_fee) total_revenue
from shippers s
join delivery_orders d on s.shipper_id = d.shipper_id
where d.order_status <> 'Cancelled'
group by s.shipper_id;

-- ---------- triggers ----------
delimiter $$

create trigger trg_after_delivery_finish
after update on delivery_orders
for each row
begin
    if new.order_status = 'Finished' and old.order_status <> 'Finished' then
        insert into delivery_log(order_id,current_location,log_time,note)
        values (new.order_id,'Tại điểm đích',now(),'Delivery Completed Successfully');
    end if;
end$$

create trigger trg_update_driver_rating
after insert on delivery_orders
for each row
begin
    if new.order_status = 'Finished' then
        update shippers
        set rating = least(5.0, rating + 0.1)
        where shipper_id = new.shipper_id;
    end if;
end$$

