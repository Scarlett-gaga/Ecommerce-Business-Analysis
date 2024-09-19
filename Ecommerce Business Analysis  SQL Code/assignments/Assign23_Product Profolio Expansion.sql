-- we want to compare the month before and after the month when we launch a thrid product
-- to see if it brings any good to the business

-- STEP 1: select relevent sessions
SELECT 
	CASE 
		WHEN ws.created_at < '2013-12-12' THEN 'A.pre_birthday_bear'
        WHEN ws.created_at >= '2013-12-12' THEN 'A.post_birthday_bear'
		ELSE 'haha'
	END AS time_period,
	-- COUNT(DISTINCT ws.website_session_id) AS sessions,
    -- COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS conversion_rate,
    -- SUM(o.price_usd) AS total_revenue,
    -- SUM(o.items_purchased) AS total_product_sold,
    SUM(o.price_usd)/COUNT(DISTINCT o.order_id) AS average_order_value,
    SUM(o.items_purchased)/COUNT(DISTINCT o.order_id) AS products_per_order,
    SUM(o.price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_session
FROM website_sessions ws
LEFT JOIN orders o
	ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 1
