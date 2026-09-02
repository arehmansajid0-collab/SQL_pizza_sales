/*
    QUESTION : Determine the top 3 most ordered pizza types based on revenue for each pizza category.
    Intuition : Revenue must be calculated per pizza, grouped by its respective category, 
            and then ranked relative only to other items in that same category. 
            Using a SQL Window Function allows you to restart the ranking counter independently for each category without needing separate queries.
    Methodology : The category_revenue CTE calculates each pizza's total revenue by joining the tables, 
            multiplying quantity by price, and grouping by category and name. 
            The rank_revenue CTE applies RANK() OVER (PARTITION BY category ORDER BY revenue DESC) to assign category-level ranks, 
            allowing the final query to filter WHERE rank_number <= 3.
*/

WITH category_revenue AS (
    SELECT 
        pt.category, 
        pt.name,
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM pizza_types pt
    JOIN pizzas  
        ON pt.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details 
        ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pt.category, pt.name
),
rank_revenue AS (
    SELECT 
        category,
        name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank_number
    FROM category_revenue
)
SELECT 
    category, 
    name, 
    revenue, 
    rank_number
FROM rank_revenue
WHERE rank_number <= 3;

/*
//////////////////////////////////////      Key Insights        ///////////////////////////////

    =>  Chicken Category High Revenue Drivers: The top three items in the Chicken category generated $136,605.50, 
        outperforming the top items of all other categories. The Thai Chicken Pizza leads overall sales across all categories at $46,525.00, 
        followed by The Barbecue Chicken Pizza ($45,759.50) and The California Chicken Pizza ($44,321.00).

Classic & Supreme Consistency:
    =>  Classic: Generated $107,619.75 among its top 3, led by The Classic Deluxe Pizza at $40,612.00.
    =>  Supreme: Generated $106,625.50 among its top 3, led by The Spicy Italian Pizza at $37,182.75.
    =>  eggie Opportunity Gap: The Veggie category’s top three items yielded $91,392.45—the lowest among the four categories. 
        The Four Cheese Pizza is the primary driver at $34,455.20, while The Mexicana Pizza ($28,650.75) 
        and The Five Cheese Pizza ($28,286.50) lag behind the $30,000 threshold.

                                        //////////  Category Breakdown  /////////////////

    Chicken:
    =>  The Thai Chicken Pizza: $46,525.00
    =>  The Barbecue Chicken Pizza: $45,759.50
    =>  The California Chicken Pizza: $44,321.00

    Classic:
    =>  The Classic Deluxe Pizza: $40,612.00
    =>  The Hawaiian Pizza: $34,265.50
    =>  The Pepperoni Pizza: $32,742.25

    Supreme:
    =>  The Spicy Italian Pizza: $37,182.75
    =>  The Italian Supreme Pizza: $36,050.75
    =>  The Sicilian Pizza: $33,392.00

    Veggie:
    =>  The Four Cheese Pizza: $34,455.20
    =>  The Mexicana Pizza: $28,650.75
    =>  The Five Cheese Pizza: $28,286.50

 */