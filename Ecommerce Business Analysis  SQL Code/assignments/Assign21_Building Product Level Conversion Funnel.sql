-- we want to see the conversion funnels for all website traffic for both products

-- STEP 1: select all pageviews for relevent sessions
CREATE TEMPORARY TABLE sessions_seeing_product_page
SELECT 
	website_session_id,
    website_pageview_id,
    pageview_url AS product_page_seen
FROM website_pageviews
WHERE created_at < '2013-04-10' AND created_at > '2013-01-06' AND pageview_url IN ('/the-original-mr-fuzzy','/the-forever-love-bear');
    
-- STEP 2: find the right pageview_url to build funnels
SELECT 
	DISTINCT wp.pageview_url
FROM sessions_seeing_product_page sspp
LEFT JOIN website_pageviews wp
	ON wp.website_session_id = sspp.website_session_id
	AND wp.website_pageview_id > sspp.website_session_id;
-- 这里是为了看看在'/the-original-mr-fuzzy'还有另一个之后能有哪些pageview

-- STEP 3: pull all pageviews and identify funnel steps
CREATE TEMPORARY TABLE session_product_level_made_it_flags
SELECT 
	website_session_id,
    CASE 
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
        ELSE 'uh'
	END AS product_seen,
    MAX(cart_page) AS cart_made_it,   -- 这里是为了让最后图标看上去像进度条,比如到达某一步之前都是1，后面是0
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM
(
SELECT 
	sspp.website_session_id,
    sspp.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_page sspp
LEFT JOIN website_pageviews wp
	ON sspp.website_session_id = wp.website_session_id
    AND sspp.website_pageview_id < wp.website_pageview_id
ORDER BY 1,2
) AS pageview_level
GROUP BY 1,2
; 

-- STEP 4: create session-level conversion funnel view
-- STEP 5: aggregate the data to assess funel performance
-- 懒得写了，总之就是疯狂COUNT