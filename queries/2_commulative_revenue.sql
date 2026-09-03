/*
    QUESTION : Analyze the cumulative revenue generated over time.
    INTENTION   : Track daily revenue accumulation to monitor business growth trends,
                    seasonality, and overall sales momentum over time.
    METHODOLOGY : Created a sub-query to get the total revenue and 
                used window function to get commulative revenue in parent query
*/

SELECT
    date,
    total_revenue,
    SUM(total_revenue) OVER(ORDER BY date) AS COMM_revenue
FROM
    (SELECT
    orders.date AS date,
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    order_details
INNER JOIN orders ON order_details.order_id = orders.order_id
INNER JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY
    date) AS revenue
;
/* 
/////////////////////////////////////       KEY INSIGHTS        /////////////////////////////////////
    =>  Total Annual Revenue: Total cumulative revenue reached $875,433.50 across 358 recorded days in 2015.
    =>  Front-Loaded Surge in January: Daily sales were exceptionally high during January 2015 
        (averaging $4,108.60/day and total revenue of $127,366.75), peaking on January 8 at $5,676.70.
    =>  Linear Growth Stability (Feb – Dec): Following the January post-launch or seasonal peak, 
        daily revenue stabilized into a highly predictable range of $2,150 to $2,370 per day, resulting in a steady, constant slope on the cumulative growth chart.
    =>  Lowest Single Day: Revenue dipped to its annual low on March 22, 2015 at $1,259.25.
 */