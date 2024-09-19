-- we want to pull conversion rates from session to oder by device type

SELECT
	ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) AS session_to_order_conversion_rate
FROM website_sessions ws
LEFT JOIN orders o USING (website_session_id)  -- 这里不是Join因为join找的是两个表的共同点，
											   -- 也就是会找到有order的website_session，那么conversion rate就一定是1
WHERE 
	ws.created_at < '2012-05-11' AND
    ws.utm_source = 'gsearch' AND
    ws.utm_campaign = 'nonbrand'
GROUP BY 1
	