
--              SQL PROJECT ON A PIZZHUT DATASET
-- 			    SOLVING A QUERRY ON A FOUR TABLE 
--              BASCI TO ADVANCE QUERRY SOLVED

-- ************************************************************************************************************************************
--  Retrieve the total number of orders placed.

select count(order_id) from orders;
-- ************************************************************************************************************************************
-- Calculate the total revenue generated from pizza sales 

select 
round(sum(order_details.quantity * pizzas.price),2)AS total_sales
from order_details join pizzas
on pizzas.pizza_id=order_details.pizza_id;
-- ************************************************************************************************************************************
-- Identify the highest-priced pizz

select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 5;
-- ************************************************************************************************************************************
-- Identify the most common pizza size ordered.

select pizzas.size, count(pizza_types.pizza_type_id) as total_count
from pizzas join pizza_types
on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizzas.size order by total_count desc limit 1;

 -- ************************************************************************************************************************************
-- List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name,sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;

-- ************************************************************************************************************************************

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by total_quantity desc limit 5;

 -- ************************************************************************************************************************************
-- Determine the distribution of orders by hour of the day.
 select hour(orders.order_time) as hours , count(orders.order_id) as total_order
 from orders
 group by hours ;
 
 
 -- ************************************************************************************************************************************
 
 -- Join relevant tables to find the category-wise distribution of pizzas.
 
 select pizza_types.category,count(pizza_types.name) as pizzs_type
 from pizza_types
 group by category order by pizzs_type desc;

-- ************************************************************************************************************************************

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(total_quantity) from 
(select orders.order_date,sum(order_details.quantity) as total_quantity
from orders join order_details
on orders.order_id=order_details.order_id
group by orders.order_date) as solution;

-- ***********************************************************************************************************************************

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join pizza_types on 
order_details.pizza_id=pizzas.pizza_id 
group by pizza_types.name
order by revenue desc limit 3; 


-- ***********************************************************************************************************************************
select pizza_types.category,
 round(sum(order_details.quantity*pizzas.price) /(select 
round(sum(order_details.quantity*pizzas.price),2) as total_sales
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id)*100,2) as revenue

from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.category
order by revenue desc;

-- ***********************************************************************************************************************************

select pizza_types.category,
round(sum(order_details.quantity*pizzas.price) / (select
 round(sum(order_details.quantity*pizzas.price),2)as total_sales
 from order_details join pizzas
 on order_details.pizza_id=pizzas.pizza_id)*100,2) as revenue
 
 from order_details join pizzas
 on order_details.pizza_id=pizzas.pizza_id
 join pizza_types
 on pizza_types.pizza_type_id=pizzas.pizza_type_id
 group by pizza_types.category order by revenue
 desc;
 
 -- ***********************************************************************************************************************************
 
 -- Analyze the cumulative revenue generated over time.alter
 select order_date,
 sum(revenue) over(order by order_date)as cum_revenue
 from
 (select orders.order_date,
 sum(order_details.quantity*pizzas.price) as revenue
 from order_details join pizzas
 on order_details.pizza_id=pizzas.pizza_id
 join orders on
 orders.order_id=order_details.order_id
 group by orders.order_date) as sales;
 
 -- ***********************************************************************************************************************************
 
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pizza_types.category , pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join pizza_types on 
pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.category,pizza_types.name
order by revenue desc
limit 3;

 


 