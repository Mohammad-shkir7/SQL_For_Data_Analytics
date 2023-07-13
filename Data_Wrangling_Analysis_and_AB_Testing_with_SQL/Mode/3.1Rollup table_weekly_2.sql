SELECT
  date(dr.date)                                 AS week,
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
      date(o.paid_at)
  ) daily_orders 
    ON dr.date >= daily_orders.Day
    AND 
    dr.d7_ago < daily_orders.Day -- dates_rollup.d7_ago < daily_orders. day between < dates_rollup.date
    -- dates_rollup.d7_ago has exactly the same dates as table dates_rollup.date but 7 days after.
GROUP BY
  date(dr.date)
--ORDER BY
--  dr.date
