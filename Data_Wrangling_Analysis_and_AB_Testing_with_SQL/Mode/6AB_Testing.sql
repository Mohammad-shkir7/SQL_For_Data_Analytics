-- Prepairing for A/B testing --> ordering the EVENT table
SELECT
  event_id,
  event_time,
  user_id,
  MAX(
    CASE
      WHEN parameter_name = 'test_assignment' THEN parameter_value
      ELSE NULL
    END
  ) AS test_assignment,
  MAX(
    CASE
      WHEN parameter_name = 'test_id' THEN parameter_value
      ELSE NULL
    END
  ) AS test_id
FROM
  dsv1069.events
WHERE
  event_name = 'test_assignment'
GROUP BY
  event_id,
  event_time,
  user_id
