-- This quere shows users' item views in 30 days range starting from A/B test date.
SELECT
  test_7.test_assignment,
  COUNT(distinct user_id) AS USERS,
  SUM(views_after_assignement) AS users_with_views,
  SUM(views_within_30d) AS views_within_30d

FROM
(
  SELECT
    assignement.test_id,
    assignement.test_assignment,
    assignement.user_id,
    MAX(CASE
          WHEN views.event_time > assignement.event_time then 1 
          ELSE 0
        END) AS views_after_assignement,
    MAX(CASE
          WHEN (views.event_time > assignement.event_time AND
                DATE_PART('day', views.event_time - assignement.event_time) <= 30) then 1 
          ELSE 0
        END) AS views_within_30d    
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
    ) assignement LEFT OUTER JOIN dsv1069.view_item_events views
      ON assignement.user_id = views.user_id
  WHERE 
    assignement.test_id = '7' 
  GROUP BY
    assignement.user_id,
    assignement.test_id,
    assignement.test_assignment
) test_7
GROUP BY  
  test_7.test_assignment
