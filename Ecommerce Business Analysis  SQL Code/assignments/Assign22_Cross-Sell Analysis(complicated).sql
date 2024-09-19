-- we want to compare the month before vs month after the adding of 2nd product to see if this is been positive

-- STEP 1: identify the relevant /cart page views and their sessions
DROP TEMPORARY TABLE sessions_seeing_cart;
CREATE TEMPORARY TABLE sessions_seeing_cart 
SELECT 
	CASE 
		WHEN created_at < '2013-09-25' THEN 'pre_cross_sell'
        WHEN created_at >= '2013-01-06' THEN 'post_cross_sell'
        ELSE 'baga'
	END AS time_period,
	website_session_id AS cart_session_id,
	website_pageview_id AS cart_pageview_id
FROM website_pageviews
WHERE created_at > '2013-08-25' AND created_at < '2013-10-25' AND pageview_url = '/cart';

-- STEP 2: see which of these cart sessions clicked through to the shipping page
CREATE TEMPORARY TABLE cart_sessions_seeing_another_page
SELECT 
	ssc.time_period,
    ssc.cart_session_id,
    MIN(wp.website_pageview_id) AS pv_id_after_cart
FROM sessions_seeing_cart ssc
LEFT JOIN website_pageviews wp
	ON ssc.cart_session_id = wp.website_session_id
	AND wp.website_pageview_id > ssc.cart_pageview_id
GROUP BY 1,2
HAVING pv_id_after_cart IS NOT NULL;


-- STEP 3: find the orders associated with the /cart sessions. Analyze products purchased, aov
CREATE TEMPORARY TABLE pre_post_sessions_orders
SELECT 
	ssc.time_period,
    ssc.cart_session_id,
    o.order_id,
    o.items_purchased,
    o.price_usd
FROM sessions_seeing_cart ssc
	INNER JOIN orders o
		ON ssc.cart_session_id = o.website_session_id;
        
SELECT 
	ssc.time_period,
    ssc.cart_session_id,
    CASE WHEN cssap.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
    CASE WHEN ppso.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
    ppso.items_purchased,
    ppso.price_usd
FROM sessions_seeing_cart ssc
LEFT JOIN cart_sessions_seeing_another_page cssap
	ON ssc.cart_session_id = cssap.cart_session_id
LEFT JOIN pre_post_sessions_orders ppso
	ON ppso.cart_session_id = ssc.cart_session_id;

-- STEP 4: aggragate and summary
SELECT 
	time_period,
    COUNT(cart_session_id) AS cart_sessions,
    SUM(clicked_to_another_page) AS clickthroughs,
    SUM(clicked_to_another_page)/COUNT(cart_session_id) AS cart_click_through_rate,
    SUM(placed_order) AS order_placed,
    COUNT(items_purchased) AS products_purchased,
    COUNT(items_purchased)/SUM(placed_order) AS products_per_order,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd)/SUM(placed_order) AS average_order_value,
    SUM(price_usd)/COUNT(DISTINCT cart_session_id) AS revenue_per_cart_session
FROM
(
SELECT 
	ssc.time_period,
    ssc.cart_session_id,
    CASE WHEN cssap.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
    CASE WHEN ppso.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
    ppso.items_purchased,
    ppso.price_usd
FROM sessions_seeing_cart ssc
LEFT JOIN cart_sessions_seeing_another_page cssap
	ON ssc.cart_session_id = cssap.cart_session_id
LEFT JOIN pre_post_sessions_orders ppso
	ON ppso.cart_session_id = ssc.cart_session_id
) AS haha
GROUP BY 1
;