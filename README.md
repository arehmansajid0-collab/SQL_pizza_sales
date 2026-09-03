# Pizza-Hut Sales Analytics

## Project Summary
This project analyses the most favourite pizzas of customers along with their categories for a restaurent pizza hut.It also includes the contribution of each pizza type  and its categorey in net revenue.

SQL queries? Check them out  here : [queries Folder](/queries)

### Research Questions
1. What is the percentage contribution of each pizza type to total revenue ?
2. What is the cumulative revenue generated over time ?
3. Which are the top 3 most ordered pizza types based on revenue for each pizza category ?
4. Determine the distribution of orders by hour of the day ?
5. What are the top 5 most ordered pizza types along with their total quantities sold ?

---

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## Data Analysis & Insights
Each query for this project aimed at investigating top selling pizzas , specific pizza type and its categorey and its contribution in net revenue. Here’s how I approached each question:
### 1. Contributition in revenue
 TO get percentage contributition of top 10  pizza I multiplied price by quantity for revenue per pizza type, divide by total overall revenue, multiply by 100, and format as a percentage.

````sql
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
````
**HERE IS THE BREAKDOWN OF 10 PIZZA TYPES THAT CONTRIBUTED THE MOST IS NET REVENUE.**
- **Chicken Pizzas Lead Individual Revenue Share:** Specialty chicken pizzas occupy the top three revenue-generating spots,led by The Thai Chicken Pizza at 5.31%, The Barbecue Chicken Pizza at 5.23%, and The California Chicken Pizza at 5.06%.
- **Dominance of Chicken Category:** The four chicken variants present in the top 10 (including The Southwest Chicken Pizza at 4.21%) collectively account for 19.81% of overall revenue.
- **Top 10 Revenue Concentration:** These top 10 individual pizza types represent 44.48% of total sales revenue.
=>  **Top Traditional & Specialty Performers**: The Classic Deluxe Pizza is the top non-chicken revenue generator at 4.64%, 
followed by The Spicy Italian Pizza (4.25%) and The Italian Supreme Pizza (4.12%).
- **Consistent Demand Across Offerings:** Revenue contribution among the top 10 items is tightly grouped, 
panning from 3.81% for The Sicilian Pizza to 5.31% for The Thai Chicken Pizza.

![contributition_in_revenue](assets\top_10_pizza_conn_to_total_revenue.png)

### 2. Commutative revenue
To fetch commutative revenue I created a sub-query to get the total revenue and 
                used window function to get commulative revenuein parent query

````sql
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
    date) AS revenue ;
````
**HERE IS THE BREAKDOWN OF THE COMMUTATIVE REVENUE GENERATED OVER TIME**
- **Total Annual Revenue:** Total cumulative revenue reached $875,433.50 across 358 recorded days in 2015.
- **Front-Loaded Surge in January:** Daily sales were exceptionally high during January 2015 
        (averaging $4,108.60/day and total revenue of $127,366.75), peaking on January 8 at $5,676.70.
- **Linear Growth Stability (Feb – Dec) :** Following the January post-launch or seasonal peak, 
        daily revenue stabilized into a highly predictable range of $2,150 to $2,370 per day, resulting in a steady, constant slope on the cumulative growth chart.
- **Lowest Single Day:** Revenue dipped to its annual low on March 22, 2015 at $1,259.25.

![commutative_revenue](assets\commulative_revenue.png)

### 3. Top 3 Pizzas 
To understand top 3 pizzas I created  category_revenue CTE that calculates total revenue for each pizza by multiplying quantity × price.Then created a rank_revenue CTE that ranks pizzas within each category, then keeps the top 3 using RANK().

````sql
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
````
**HERE IS THE BREAKDOWN OF TOP 3 PIZZAS TYEPS BASES ON REVENUE FOR EACH PIZZA TYPE**

### **Chicken Category High Revenue Drivers:** 
- The top three items in the Chicken category generated $136,605.50,outperforming the top items of all other categories.
- The Thai Chicken Pizza leads overall sales across all categories at $46,525.00, followed by The Barbecue Chicken Pizza ($45,759.50) and The California Chicken Pizza ($44,321.00).

### **Classic & Supreme Consistency:**
- Classic: Generated $107,619.75 among its top 3, led by The Classic Deluxe Pizza at $40,612.00.
- Supreme: Generated $106,625.50 among its top 3, led by The Spicy Italian Pizza at $37,182.75.
-  Opportunity Gap: The Veggie category’s top three items yielded $91,392.45—the lowest among the four categories.The Four Cheese Pizza is the primary driver at $34,455.20, while The Mexicana Pizza ($28,650.75) 
and The Five Cheese Pizza ($28,286.50) lag behind the $30,000 threshold.

### Categorey Breakdown
 **Chicken:** 
- The Thai Chicken Pizza: $46,525.00
- The Barbecue Chicken Pizza: $45,759.50
- The California Chicken Pizza: $44,321.00

 **Classic:**
- The Classic Deluxe Pizza: $40,612.00
- The Hawaiian Pizza: $34,265.50
- The Pepperoni Pizza: $32,742.25

 **Supreme:**
- The Spicy Italian Pizza: $37,182.75
- The Italian Supreme Pizza: $36,050.75
- The Sicilian Pizza: $33,392.00

 **Veggie:**
- The Four Cheese Pizza: $34,455.20
- The Mexicana Pizza: $28,650.75
- The Five Cheese Pizza: $28,286.50

![commutative_revenue](assets\commulative_revenue.png)