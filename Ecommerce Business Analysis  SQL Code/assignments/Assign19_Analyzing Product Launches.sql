SELECT 
YEAR(ws.created_at) AS year,
MONTH(ws.created_at) AS month,
COUNT(DISTINCT ws.website_session_id) AS sessions,
COUNT(DISTINCT o.order_id) AS orders,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS conversion_rate,
SUM(o.price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_session,
COUNT(CASE WHEN o.primary_product_id = 1 THEN 1 ELSE NULL END) AS product_one_orders,
COUNT(CASE WHEN o.primary_product_id = 2 THEN 1 ELSE NULL END) AS product_two_orders
FROM website_sessions ws
LEFT JOIN orders o
	ON ws.website_session_id = o.website_session_id
WHERE ws.created_at > '2012-04-01' AND ws.created_at < '2013-04-01'
GROUP BY 1,2 