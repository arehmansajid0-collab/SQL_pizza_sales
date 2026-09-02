/* 
    QUESTION    : Determine the distribution of orders by hour of the day.
    INTENTION   : Identify peak ordering hours to optimize kitchen staffing, 
                  delivery driver dispatch, and store operating hours.
    METHODOLOGY : Extract the hour component from the order timestamp, count total 
                  orders for each hour, and group results by hour.
*/

SELECT
    HOUR(o.time) AS order_hour,
    COUNT(o.order_id) AS total_orders
FROM
    orders o
GROUP BY
    order_hour
ORDER BY
    total_orders DESC;


/* ///////////////////////////////      KEY INSIGHTS        ////////////////////////////////////////////
    =>  Bimodal Peak Pattern: Orders follow a distinct two-peak distribution corresponding to meal hours:
    =>  Lunch Peak (12:00 PM – 1:00 PM): Peak volume reaches 2,520 orders at 12:00 PM and remains high at 2,455 orders at 1:00 PM.
    =>  Dinner Peak (5:00 PM – 6:00 PM): A secondary surge occurs during dinner hours, 
        peaking at 2,399 orders at 6:00 PM and 2,336 orders at 5:00 PM.
    =>  Core Operating Window: Over 73% of total orders occur between 12:00 PM and 7:00 PM.
    =>  Off-Peak Operations: Early morning (9:00 AM – 10:00 AM) and late night (11:00 PM) experience minimal activity, 
        recording under 30 orders combined.

*/
