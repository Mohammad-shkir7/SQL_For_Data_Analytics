-- results of our A/B testing --> orders_after_assignment, items_after_assignment and total_revenue
SELECT
  assignement.test_id,
  assignement.test_assignment,
  assignement.user_id,
  COUNT(DISTINCT (
    CASE
      WHEN orders.created_at > assignement.event_time then orders.invoice_id 
      ELSE NULL
    END
  )) AS orders_after_assignement,
  COUNT(DISTINCT (
    CASE
      WHEN orders.created_at > assignement.event_time then orders.line_item_id 
      ELSE NULL
    END
  )) AS items_after_assignement,
  SUM(DISTINCT (
    CASE
      WHEN orders.created_at > assignement.event_time then orders.price 
      ELSE 0
    END
  )) AS total_revenue  
FROM
  (
    SELECT
      event_id, 
      event_time,
      user_id,
      MAX(CASE
        WHEN parameter_name = 'test_assignment' then parameter_value
        ELSE NULL
      END) AS test_assignment,
      MAX(CASE
        WHEN parameter_name = 'test_id' then parameter_value
        ELSE NULL
      END) AS test_id
    
    FROM
      dsv1069.events
    WHERE
      event_name = 'test_assignment'
    GROUP BY
      event_id, 
      event_time,
      user_id
  ) assignement LEFT JOIN dsv1069.orders orders
    ON assignement.user_id = orders.user_id
    --AND assignement.event_time < orders.paid_at
GROUP BY
  assignement.test_id,
  assignement.test_assignment,
  assignement.user_id
ORDER BY
  4 DESC
