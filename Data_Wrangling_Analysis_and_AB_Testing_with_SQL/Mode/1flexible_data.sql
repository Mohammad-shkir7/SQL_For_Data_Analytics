SELECT
  event_id,
  user_id,
  event_time,
  platform,
  MAX(
    CASE
      -- usnig max to get rid of nulls 
      WHEN parameter_name = 'item_id' THEN cast(parameter_value AS int)
      ELSE NULL
    END
  ) AS item_id,
  MAX(
    CASE
      -- max even works with strings in order to get rid of nulls 
      WHEN parameter_name = 'referrer' THEN parameter_value
      ELSE NULL
    END
  ) AS referrer -- MAX FUNCTION MUST BE USED FOR BOTH COLUMNS IN ORDER TO ELIMINATE NULLS
FROM
  dsv1069.events -- dsc1069 is the default database in this course
WHERE
  event_name = 'view_item'
GROUP BY
  event_id,
  user_id,
  event_time,
  platform
ORDER BY
  event_id
