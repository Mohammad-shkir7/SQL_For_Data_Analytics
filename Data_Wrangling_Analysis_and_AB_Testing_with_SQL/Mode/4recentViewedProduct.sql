-- Last viewed product by each user_id
SELECT
  last_item.*,
  users.email_address
FROM
  (
    SELECT
      ranked_orders.user_id         AS user_id,
      ranked_orders.item_id         AS item_id,
      items.name                    AS item_name,
      ranked_orders.order_date      AS order_date,
      items.price                   AS item_price
    FROM
      (
        SELECT
          user_id                   AS user_id,
          item_id                   AS item_id,
          event_time                AS order_date,
          dense_rank() over(
            PARTITION by user_id
            ORDER BY
              event_time
          )                         AS ranked
        FROM
          dsv1069.view_item_events
      ) ranked_orders
      INNER JOIN dsv1069.items ON ranked_orders.item_id = items.id
    WHERE
      ranked_orders.ranked = 1
  ) last_item INNER JOIN dsv1069.users
  ON last_item.user_id = users.id
