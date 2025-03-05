-- 1. Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders_placed FROM ORDERS;

-- 2. Calculate the total revenue generated from pizza sales.
SELECT ROUND((pizzas.price * order_details.quantity), 1) AS total_revenue FROM pizzas 
	JOIN order_details ON pizzas.pizza_id = order_details.pizza_id;
    
-- 3. Identify the highest-priced pizza.
SELECT pizzas_types.name, pizzas.price FROM pizzas_types
	JOIN pizzas ON pizzas_types.pizza_type_id = pizzas.pizza_type_id 
	ORDER BY pizzas.price DESC LIMIT 1;
    
-- 4. Identify the most common pizza size ordered.
SELECT pizzas.size, COUNT(order_details.order_details_id) AS total_order_cnt FROM pizzas 
	JOIN order_details ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY pizzas.size
    ORDER BY total_order_cnt DESC LIMIT 1;
    
-- 5. List the top 5 most ordered pizza types along with their quantities.
SELECT pizzas_types.name, SUM(order_details.quantity) AS quantity FROM pizzas_types
	JOIN pizzas ON pizzas_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizzas_types.name
    ORDER BY quantity DESC LIMIT 5;
    
-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pizzas_types.category, SUM(order_details.quantity) AS quantity FROM pizzas_types 
	JOIN pizzas ON pizzas_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
    GROUP BY pizzas_types.category
    ORDER BY quantity;
    
-- 7. Determine the distribution of orders by hour of the day.
SELECT HOUR(time) AS Hour,COUNT(order_id) AS order_Cnt FROM orders
	GROUP BY hour(time);
    
-- 8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT category, COUNT(name) AS Cnt_name FROM pizzas_types
	GROUP BY category
    ORDER BY Cnt_name;
    
-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(quantity), 0) AS Avg_pizza_ordered_per_day FROM
	(SELECT orders.date, SUM(order_details.quantity) AS quantity FROM orders
	JOIN order_details ON orders.order_id = order_details.order_id
	Group by orders.date) AS order_quantity;

-- 10. Determine the top 3 most ordered pizza types based on revenue.
SELECT pizzas_types.name, SUM(pizzas.price * order_details.quantity) AS revenue FROM pizzas_types
	JOIN pizzas ON pizzas_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
    GROUP BY pizzas_types.name
    ORDER BY revenue desc LIMIT 3;
    
-- 11. Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizzas_types.name,
    ROUND(SUM(pizzas.price * order_details.quantity) / (SELECT 
                    ROUND((pizzas.price * order_details.quantity),
                                1) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizzas_types
        JOIN
    pizzas ON pizzas_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas_types.name
ORDER BY revenue DESC
LIMIT 3; 

-- 12. Analyze the cumulative revenue generated over time.
SELECT 
    sales.date, 
    SUM(sales.Revenue) OVER (ORDER BY sales.date) AS cum_revenue 
FROM 
    (SELECT orders.date, SUM(pizzas.price * order_details.quantity) AS Revenue 
     FROM order_details 
     JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id 
     JOIN orders ON orders.order_id = order_details.order_id
     GROUP BY orders.date) AS sales
ORDER BY sales.date;

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name, revenue FROM
(SELECT category, name,revenue, rank() over(partition by category order by revenue desc) as rn FROM
(SELECT pizzas_types.category, pizzas_types.name, SUM((order_details.quantity) * pizzas.price) AS revenue FROM pizzas_types
JOIN pizzas ON pizzas_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas_types.category,pizzas_types.name) AS a) AS b
where rn<=3;









    
    












