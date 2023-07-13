/* 
  Checking the metrics of A/B test conducted on test 7 (test_id=7), 
  the we're able to calculate sucess rate, p-value and improvement.
  To calculate A/B testing results you can use the following link:
  https://thumbtack.github.io/abba/demo/abba.html
*/
SELECT
  test_7.test_assignment,
  COUNT(DISTINCT user_id) AS USERS,
  SUM(orders_after_assignement) AS users_with_orders
FROM
(
  SELECT
    assignement.test_id,
    assignement.test_assignment,
    assignement.user_id,
    CASE
      WHEN orders.created_at > assignement.event_time then 1 
      ELSE 0
    END AS orders_after_assignement
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
      --AND assignement.event_time < orders.paid_at
  WHERE 
    assignement.test_id = '7' 
  GROUP BY
    assignement.test_id,
    assignement.test_assignment,
    assignement.user_id,
    orders.created_at,
    assignement.event_time
) test_7
GROUP BY  
  test_7.test_assignment
