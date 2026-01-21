select * ,(select sum(total_amount) from orders where customer_id=customers.id
as ' Total money ' from customers
where id in (
select customer_id from orders 
group by customer_id
having sum(total_amount)=(
select max(Total_money) from(
select sum( total_amount) as Total_money from orders
group by customer_id) t )
);
-- b5
-- ko sdung join sdung group having

-- cach 2 : don gian
-- vs yc lay thong tin khach hang co tong so tien mua hang nhieu nhat
select c.*,sum(total_amount ) as 'Total money'
 from customers c join orders od on c.id =od.customer_id
 group by c.id
 having sum(total_amount)=(
  select  sum(total_amount) from orders
  group by customer_id
  order by  sum(total_amount) desc
  limit 1
  );
  
-- sync commit
