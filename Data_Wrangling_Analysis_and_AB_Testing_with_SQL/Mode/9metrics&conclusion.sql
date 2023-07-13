-- In the following quere we are calculating Standard deviation and average invoices for each test id and assignment.
-- Of course, we can calculate other variables, like line_item or total revenue.
SELECT
  test_id,
  test_assignment,
  COUNT(user_id) AS users,
  AVG(invoices) AS avg_invoices,
  STDDEV(invoices) AS stddev_invoices
FROM
(
  SELECT
    assignement.user_id,
    assignement.test_id,
    assignement.test_assignment,
    COUNT(DISTINCT CASE WHEN orders.created_at > assignement.event_time THEN orders.invoice_id ELSE NULL END)
      AS invoices,
    COUNT(DISTINCT CASE WHEN orders.created_at > assignement.event_time THEN orders.line_item_id ELSE NULL END)
      AS line_items,
    SUM(CASE WHEN orders.created_at > assignement.event_time THEN orders.price ELSE 0 END)
      AS total_revenue
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
    ) assignement LEFT OUTER JOIN dsv1069.orders orders
      ON assignement.user_id = orders.user_id
  GROUP BY
    assignement.user_id,
    assignement.test_id,
    assignement.test_assignment
) test_7
GROUP BY 
  test_id,
  test_assignment
ORDER BY 
  test_id
