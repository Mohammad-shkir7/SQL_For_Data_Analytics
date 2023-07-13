-- The following quere returns data for those users who have ordered the same product in different dates more than once. 
SELECT
  re_order_user.*
FROM
(
  SELECT
    re_order_times.*,
    dense_rank() over (partition by re_order_times.user_id ORDER BY re_order_times.date) as re_order_times
  FROM
  (
    SELECT
      item_count.*
    FROM
    (
      SELECT -- number of users who ordered
        orders.user_id AS user_id,
        orders.item_id AS item_id,
        orders.paid_at AS date,
        COUNT(orders.item_id) over(partition BY orders.user_id, orders.item_id) AS item_count
      FROM 
        dsv1069.orders
      WHERE
        orders.item_id is NOT NULL
         
      ORDER by 
        COUNT(orders.item_id) over(partition BY orders.user_id, orders.item_id) DESC,
        user_id
    ) item_count
    WHERE
      item_count.item_count >1 
    GROUP BY
        item_count.item_id,
        item_count.user_id,
        item_count.date,
        item_count
    ORDER BY user_id,item_count desc
  ) re_order_times
) re_order_user
WHERE
  re_order_times >1
