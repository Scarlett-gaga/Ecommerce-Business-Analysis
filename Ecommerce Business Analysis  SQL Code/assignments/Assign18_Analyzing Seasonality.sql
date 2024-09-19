-- monthly and weekly volume patterns

SELECT 
	YEAR(ws.created_at) AS yr,
    MONTH(ws.created_at) AS mo,
    MIN(DATE(ws.created_at)) AS week_start,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders
FROM website_sessions ws
LEFT JOIN orders o
	ON o.website_session_id = ws.website_session_id
WHERE ws.created_at < '2013-01-01'
GROUP BY 1,2
