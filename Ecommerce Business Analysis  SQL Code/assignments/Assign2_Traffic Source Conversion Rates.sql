-- Since gsearch nonbrand is our major traffic source, we want to see if those sessions are driving sales.
-- Calculate the conversion rate from session to order based on what we're paying for clicks(gsearch nonbrand), 
-- we'll need a CVR at leat 4% to make numbers work

SELECT 
	COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) AS session_to_order_conv_rate
FROM website_sessions ws
LEFT JOIN orders o
	ON o.website_session_id = ws.website_session_id
    
WHERE 
	ws.created_at < '2012-04-14' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'
	
	

    