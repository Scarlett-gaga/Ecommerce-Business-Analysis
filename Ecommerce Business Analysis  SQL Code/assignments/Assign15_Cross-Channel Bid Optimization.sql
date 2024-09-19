SELECT 
	ws.device_type,
    ws.utm_source,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id) / COUNT(ws.website_session_id) AS conv_rate
FROM website_sessions ws
LEFT JOIN orders o
	ON o.website_session_id = ws.website_session_id
WHERE 
	ws.utm_source IN ('gsearch','bsearch') 
    AND ws.created_at > '2012-08-22'
    AND ws.created_at < '2012-09-19'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY 1,2
ORDER BY conv_rate DESC