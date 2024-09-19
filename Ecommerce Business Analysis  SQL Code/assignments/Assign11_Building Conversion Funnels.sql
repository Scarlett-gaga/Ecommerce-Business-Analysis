-- we want to build a full conversion funnel, analyzing how many customers make it to each step


CREATE TEMPORARY TABLE funnel_data
SELECT                                     -- 这里的MAX主要是pivot的作用
	website_session_id,
    MAX(to_products) AS product_made_it,
    MAX(to_mrfuzzy) AS mrfuzzy_made_it,
    MAX(to_cart) AS cart_made_it,
    MAX(to_shipping) AS shipping_made_it,
    MAX(to_billing) AS billing_made_it,
    MAX(to_thankyou) AS thankyou_made_it
FROM (
SELECT 
	ws.website_session_id,
    wp.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE NULL END AS to_products,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE NULL END AS to_mrfuzzy,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE NULL END AS to_cart,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE NULL END AS to_shipping,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE NULL END AS to_billing,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE NULL END AS to_thankyou
FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id
WHERE utm_campaign = 'nonbrand' AND utm_source = 'gsearch' AND ws.created_at < '2012-09-05' AND ws.created_at > '2012-08-05' 
ORDER BY 1, wp.created_at
) AS haha
GROUP BY 1;

DROP TEMPORARY TABLE funnel_data1;
CREATE TEMPORARY TABLE funnel_data1
SELECT 
	COUNT(website_session_id) AS sessions,
	COUNT(product_made_it) AS product_clicks,
    COUNT(mrfuzzy_made_it) AS mrfuzzy_clicks,
    COUNT(cart_made_it) AS cart_clicks,
    COUNT(shipping_made_it) AS shipping_clicks,
    COUNT(billing_made_it) AS billing_clicks,
    COUNT(thankyou_made_it) AS thankyou_clicks
FROM funnel_data;



SELECT 
		product_clicks/sessions AS lander_click_rate,
        mrfuzzy_clicks/product_clicks AS product_click_rate,
        cart_clicks/mrfuzzy_clicks AS mrfuzzy_click_rate,
        shipping_clicks/cart_clicks AS cart_click_rate,
        billing_clicks/shipping_clicks AS shipping_click_rate,
        thankyou_clicks/billing_clicks AS billing_click_rate
FROM funnel_data1




