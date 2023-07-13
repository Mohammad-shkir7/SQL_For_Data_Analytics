--5 -> detailed days
SELECT
  new.date AS Date,
  COALESCE(new.users, 0) AS new_users,
  COALESCE(deleted.users, 0) AS deleted_users,
  COALESCE(merged.users, 0) AS merged_users,
  (
    new.users - COALESCE(deleted.users, 0) - COALESCE(merged.users, 0)
  ) AS net_new_user
FROM
  (
    SELECT
      date(created_at) AS date,
      COUNT(id) AS users
    FROM
      dsv1069.users
    WHERE
      created_at IS NOT NULL
    GROUP BY
      date(created_at)
  ) new
  LEFT JOIN (
    SELECT
      date(deleted_at) AS date,
      COUNT(id) AS users
    FROM
      dsv1069.users
    WHERE
      deleted_at IS NOT NULL
    GROUP BY
      date(deleted_at)
  ) deleted ON new.date = deleted.date
  LEFT JOIN (
    SELECT
      date(merged_at) AS date,
      COUNT(id) AS users
    FROM
      dsv1069.users
    WHERE
      merged_at IS NOT NULL
    GROUP BY
      1
  ) merged ON deleted.date = merged.date --group by new.date
ORDER BY
  new.date ASC
