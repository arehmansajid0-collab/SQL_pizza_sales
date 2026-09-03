/* 
    QUESTION    : List the top 5 most ordered pizza types along with their total quantities sold.
    INTENTION   : Identify top-performing pizzas to optimize inventory, scale production,
                  and leverage popular flavor profiles across menu offerings.
    METHODOLOGY : Join pizza metadata with order details, aggregate total quantity per 
                  pizza type, and rank the top 5 records in descending order.
*/
use pizza_hut;
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_ordered
FROM
    pizza_types pt
INNER JOIN 
    pizzas p ON pt.pizza_type_id = p.pizza_type_id 
INNER JOIN 
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY
    pt.name
ORDER BY
    total_quantity_ordered DESC
LIMIT 5;

/*
//////////////////////////////////      KEY INSIGHTS        ///////////////////////////////////
    =>  Consistent High Demand Across Top Tier: All five top-selling pizzas perform within a tight range of 2,540 to 2,624 units,
        representing a total volume of 12,948 pizzas across these top items.
    =>  Top Performer: The Pepperoni Pizza leads sales at 2,624 units, 
        closely followed by The Classic Deluxe Pizza at 2,609 units (a minimal difference of only 15 units).
Balanced Flavor Preferences:
    =>  Classic & Meat Favorites: Pepperoni, Classic Deluxe, and Hawaiian remain steady customer essentials.
    =>  Specialty Chicken Demand: Barbecue Chicken (2,602 units) and Thai Chicken (2,540 units) show strong, 
        reliable demand for chicken-based offerings.
    =>  Tight Sales Spread: The variance between the #1 seller (Pepperoni) and the #5 seller (Thai Chicken) is only 84 units (3.2%), 
        indicating consistent preference for all top 5 menu offerings rather than reliance on a single dominant product.
 */