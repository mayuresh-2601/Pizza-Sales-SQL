-- Data Analysis Using SQL
-- Pizza Sales Data Analysis

--  Create Database
create database if not exists Pizza_Sales;

-- Select the Database

use Pizza_sales;

-- Data import 
-- Verify Data Import (when CSV files are small and easy to import)

select * from pizzas;
select * from pizza_types;

-- NOTE:
-- If the CSV file is large or not suitable for direct import using
-- the "Data Import Wizard", you must create the table manually 
-- BEFORE loading the data.

-- Orders Table
create table if not exists orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
 );
 
select * from orders;

-- Order Details Table
create table if not exists order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id)
 );
 
 select * from order_details;




-- Basic:
-- Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;

-- List all pizza categories.

select distinct category from pizza_types;

-- Convert all pizza names to uppercase
select upper(name) as pizza_name_upper
from pizza_types;

-- Display pizza names in lowercase
select lower(name) as pizza_name_lower
from pizza_types;

-- Show the length of each pizza name
select name, length(name) as name_length
from pizza_types;

-- Show pizza name with category concatenated
select concat(name, ' - ', category) as full_label
from pizza_types;

-- Sort pizzas by price low to high
select *
from pizzas
order by price asc;

-- Sort pizza types alphabetically
select *
from pizza_types
order by name asc;

-- Sort orders by latest order date first
select *
from orders
order by order_date desc;

-- Get pizza names in title case
select concat(ucase(left(name,1)), lcase(substring(name,2))) as title_case
from pizza_types;

-- Find pizzas with names longer than 15 characters
select name, length(name) as len
from pizza_types
where length(name) > 15;

-- Extract year from order date
select year(order_date)
from orders;

-- Highest quantity sold for each pizza
select pizza_id, max(quantity)
from order_details
group by pizza_id;

-- Average quantity rounded
select round(avg(quantity),2)
from order_details;

-- Fetch the list of pizzas with price > 20 sorted by price descending.

select pizza_id, price
from pizzas
where price > 20
order by price desc;

-- Find number of orders placed on weekends.

select count(*) as weekend_orders
from orders
where dayofweek(order_date) in (1,7);

-- Calculate the total revenue generated from pizza sales.
 
 select round(sum(ods.quantity * p.price),2) as Total_sales
 from order_details as ods
 join pizzas as p
 on p.pizza_id = ods.pizza_id;

-- List all pizzas with the keyword "chicken" in name.

select * from pizza_types
where name like '%chicken%';

-- Identify the highest-priced pizza.

select pt.name, p.price
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc limit 1;

-- Retrieve first 10 records from the orders table sorted by date.

select * from orders
order by order_date
limit 10;

-- Find the earliest and latest order date.

select min(order_date) as first_order,
       max(order_date) AS last_order
from orders;

-- Identify the most common pizza size ordered.
 
select p.size, count(odt.order_details_id) as order_count
from pizzas as p
join order_details as odt
on p.pizza_id = odt.pizza_id
group by p.size
order by order_count desc;

-- List the top 5 most ordered pizza types 
-- along with their quantities.
 
select pt.name, sum(odt.quantity) as total_quantity
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as odt
on odt.pizza_id = p.pizza_id
group by pt.name
order by total_quantity desc 
limit 5;
 



-- Intermediate:

-- Extract month from order date
select order_id, month(order_date) as order_month
from orders;

-- Extract day name (e.g., monday)
select order_id, dayname(order_date) as day_name
from orders;

-- Format date as dd-mm-yyyy
select date_format(order_date, '%d-%m-%y') as formatted_date
from orders;

-- Random discount between 5–10%
select pizza_id, price, price - (price * (rand() * 0.05 + 0.05)) as discounted_price
from pizzas;

-- Compare weekday vs weekend sales.

select
    case when dayofweek(order_date) in (1,7) then 'Weekend' 
         else 'Weekday' end as day_type,
    round(sum(od.quantity * p.price),2) as revenue
from orders o
join order_details od on od.order_id = o.order_id
join pizzas p on p.pizza_id = od.pizza_id
group by day_type;

-- Join the necessary tables to find the total quantity 
-- of each pizza category ordered.

select pt.category, 
sum(odt.quantity) as total_quantity
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as odt
on odt.pizza_id = p.pizza_id
group by category
order by total_quantity desc ;

-- Find pizza type with lowest revenue.

select pt.name, sum(od.quantity * p.price) as revenue
from pizza_types pt
join pizzas p on p.pizza_type_id = pt.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
group by pt.name
order by revenue asc
limit 1;

-- Determine the distribution of orders by hour of the day.
 
select  hour(order_time) Hour,
count(order_id) Order_count
from orders
group by hour(order_time);
 
-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name)
from pizza_types
group by category; 
 
-- Group the orders by date and calculate 
-- the average number of pizzas ordered per day. 

select 
round(avg(total_quantity),0) Avg_Pizza_Per_Day
from
(select o.order_date,
sum(odt.quantity) total_quantity
from orders o
join order_details odt
on o.order_id = odt.order_id
group by o.order_date) as order_quantity ;
 
-- Determine the top 3 most ordered pizza types based on revenue. 
 
select pt.name,
round(sum(odt.quantity *  p.price),0) revenue
from pizza_types pt
join pizzas p
on p.pizza_type_id = pt.pizza_type_id
join order_details odt
on odt.pizza_id = p.pizza_id
group by pt.name 
order by revenue desc
limit 3;
 

 
 
-- Advanced:

-- Sort by revenue, then by price when revenue ties
select p.pizza_id, sum(quantity * price) as revenue, price
from order_details od
join pizzas p on p.pizza_id = od.pizza_id
group by p.pizza_id, price
order by revenue desc, price desc;

-- Apply mathematical functions ceil and floor
select pizza_id,
       price,
       ceil(price) as ceil_price,
       floor(price) as floor_price
from pizzas;


-- Calculate the percentage contribution of each pizza type to total revenue. 

select 
    pt.category,
    round(
        (
            sum(odt.quantity * p.price) /
            (
                select sum(odt2.quantity * p2.price)
                from order_details odt2
                join pizzas p2 
                    on p2.pizza_id = odt2.pizza_id
            )
        ) * 100,
    0) as revenue
from pizza_types pt
join pizzas p
    on p.pizza_type_id = pt.pizza_type_id
join order_details odt
    on odt.pizza_id = p.pizza_id 
group by pt.category
order by revenue desc;

-- Analyze the cumulative revenue generated over time.

select dates,
  sum(revenue)
  over(order by dates) cumulative
  from
             (select o.order_date dates,
                   sum(odt.quantity * p.price) revenue
                   from order_details odt
                   join pizzas p
				   on odt.pizza_id = p.pizza_id
				   join orders o
				   on o.order_id = odt.order_id
                   group by dates) sales;


-- Determine the top 3 most ordered pizza types 
-- based on revenue for each pizza category.

select name, revenue
from
      (select category, name, revenue,
         rank() over(partition by category 
         order by revenue desc) as rn
         from
                  (select pt.category, pt.name,
                      sum((odt.quantity) * p.price) revenue
                     from pizza_types pt
						join pizzas p
						on pt.pizza_type_id = p.pizza_type_id
						join order_details odt
						on odt.pizza_id = p.pizza_id
						group by pt.category, pt.name) a ) b
where rn <= 3;


-- Create a view for daily revenue.

create view daily_revenue as
select o.order_date,
      sum(od.quantity * p.price) revenue
from order_details od
join pizzas p 
on p.pizza_id = od.pizza_id
join orders o 
on o.order_id = od.order_id
group by o.order_date;

-- Using the view, find top 10 highest revenue days.

select * from daily_revenue
order by revenue desc
limit 10;


-- Identify hourly peak revenue using window functions.

select hour,
       revenue,
       rank() over(order by revenue desc) as rn
from (
   select hour(o.order_time) as hour,
           sum(od.quantity * p.price) as revenue
    from orders o
    join order_details od 
    on od.order_id = o.order_id
    join pizzas p 
    on p.pizza_id = od.pizza_id
    group by hour
) x;


-- Running total of revenue for each month.

select month,
       revenue,
       sum(revenue) over(order by month) as running_total
from(
    select date_format(order_date, '%y - %m') month,
           sum(odt.quantity * p.price) revenue
    from orders o
    join order_details odt 
    on o.order_id = odt.order_id
    join pizzas p 
    on p.pizza_id = odt.pizza_id
    group by month
)y;

delimiter $$

-- Procedure to calculate daily revenue
create procedure dailyrevenue(in d date)
begin
    select sum(od.quantity * p.price) as revenue
    from orders o
    join order_details od on od.order_id = o.order_id
    join pizzas p on p.pizza_id = od.pizza_id
    where o.order_date = d;
end $$

delimiter ;

call dailyrevenue('2015-06-15');


 -- view showing total sales (revenue) per pizza 
 
create view vw_pizza_revenues as
select p.pizza_id,
       sum(odt.quantity * p.price) as revenue
from pizzas p
join order_details odt
    on odt.pizza_id = p.pizza_id
group by p.pizza_id;

--  view showing only weekend orders (sunday = 1, saturday = 7)
create view vw_weekend_orders as
select *
from orders
where dayofweek(order_date) in (1, 7);

--  view showing pizzas that were never sold 
create view vw_unsold_pizzas as
select p.pizza_id
from pizzas p
left join order_details od 
    on od.pizza_id = p.pizza_id
where od.pizza_id is null;

select * from vw_pizza_revenues;
select * from vw_weekend_orders;
select * from vw_unsold_pizzas;


