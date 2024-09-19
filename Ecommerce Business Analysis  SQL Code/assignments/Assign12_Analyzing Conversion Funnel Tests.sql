-- we want to see if the billing to order conversion rate of both original billing page and an improved one

-- find the first_pageview_id and time
SELECT 
	MIN(website_pageview_id) AS first_pageview_id,
	MIN(created_at) AS first_pageview_time
FROM website_pageviews
WHERE pageview_url = '/billing-2';

SELECT 
	pageview_url AS billing_version_seen,
    COUNT(website_pageview_id) AS sessions,
    COUNT(order_id) AS orders,
    COUNT(order_id)/COUNT(website_pageview_id) AS billing_to_order_rate
FROM(
SELECT 
	wp.website_pageview_id,
    wp.pageview_url,
    o.order_id
FROM website_pageviews wp
LEFT JOIN orders o
	ON o.website_session_id = wp.website_session_id
WHERE wp.website_pageview_id >= 53550 
	AND wp.created_at < '2012-11-10'
    AND wp.pageview_url IN ('/billing','/billing-2')
) AS billing_sessions_w_orders
GROUP BY 1

