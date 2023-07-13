-- counting dailt orders EVERYDAY even though the dataset it self didn't contain every single day!
SELECT
  dr.date                                       AS day,
  COALESCE(SUM(daily_orders.Orders) , 0)        AS total_orders,
  COALESCE(SUM(daily_orders.Line_items), 0)     AS total_line_items
FROM
  dsv1069.dates_rollup dr
  LEFT OUTER JOIN (
    SELECT
      date(o.paid_at)                 AS DAY,
      COUNT(DISTINCT o.invoice_id)    AS Orders,
      COUNT(DISTINCT o.line_item_id)  AS Line_items
    FROM
      dsv1069.orders o
    GROUP BY
      o.paid_at
  ) daily_orders ON dr.date = daily_orders.Day
GROUP BY
  dr.date
ORDER BY
  dr.date
