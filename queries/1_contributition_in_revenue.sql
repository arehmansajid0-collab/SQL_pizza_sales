/* 
    QUESTION    : Calculate the percentage contribution of each pizza type to total revenue.
    INTENTION   : Understand which individual pizza types generate the highest proportion of overall income.
    METHODOLOGY : Multiply price by quantity for revenue per pizza type, divide by total 
                  overall revenue, multiply by 100, and format as a percentage.
*/

use pizza_hut;
SELECT
    pt.name AS pizza_type_name,
    ROUND(
        (SUM(od.quantity * p.price) * 100.0) / 
        (SELECT SUM(od_sub.quantity * p_sub.price) 
         FROM order_details  od_sub
         JOIN pizzas p_sub ON od_sub.pizza_id = p_sub.pizza_id), 
        2
    ) AS percentage_contribution
FROM
    order_details od
INNER JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
INNER JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
    pt.name
ORDER BY
    percentage_contribution DESC
LIMIT 10;

/*
////////////////////////////        KEY INSIGHTS        ////////////////////////////////////
    =>  Chicken Pizzas Lead Individual Revenue Share: Specialty chicken pizzas occupy the top three revenue-generating spots, 
        led by The Thai Chicken Pizza at 5.31%, The Barbecue Chicken Pizza at 5.23%, and The California Chicken Pizza at 5.06%.
    =>  Dominance of Chicken Category: The four chicken variants present in the top 10 
        (including The Southwest Chicken Pizza at 4.21%) collectively account for 19.81% of overall revenue.
    =>  Top 10 Revenue Concentration: These top 10 individual pizza types represent 44.48% of total sales revenue.
    =>  Top Traditional & Specialty Performers: The Classic Deluxe Pizza is the top non-chicken revenue generator at 4.64%, 
        followed by The Spicy Italian Pizza (4.25%) and The Italian Supreme Pizza (4.12%).
    =>  Consistent Demand Across Offerings: Revenue contribution among the top 10 items is tightly grouped, 
        spanning from 3.81% for The Sicilian Pizza to 5.31% for The Thai Chicken Pizza.
     */