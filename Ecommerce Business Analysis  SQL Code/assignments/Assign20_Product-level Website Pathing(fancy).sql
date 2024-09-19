-- we want to look at sessions which hit the product page and see where they went next

-- STEP 1: finding the /products pageviews we care about
CREATE TEMPORARY TABLE product_pageviews
SELECT 
	website_session_id,
    website_pageview_id,
    created_at,
    CASE
		WHEN created_at < '2013-01-06' THEN 'A.pre_product_2'
        WHEN created_at >= '2013-01-06' THEN ' B.post_product_2'
        ELSE 'uh...check logic'
	END AS time_period
 FROM website_pageviews
 WHERE created_at < '2013-04-06' AND created_at > '2012-10-06' -- start of 3 month before product 2 launch
	AND  pageview_url = '/products'
ORDER BY 1;

-- STEP 2: find the next pageview_url associated with any applicable next pageview_id
DROP TEMPORARY TABLE sessions_w_next_pageview_id;
CREATE TEMPORARY TABLE sessions_w_next_pageview_id
SELECT 
	pp.time_period,
    pp.website_session_id,
    MIN(wp.website_pageview_id) AS min_next_pageview_id
FROM product_pageviews pp
LEFT JOIN website_pageviews wp
	ON pp.website_session_id = wp.website_session_id
	AND wp.website_pageview_id > pp.website_pageview_id -- important.保证返回所有/products之后的pageview_id
GROUP BY 1,2;

-- STEP 3: find the pageview_url that associated with any next applicable pageview_id
DROP TEMPORARY TABLE sessions_w_next_pageview_url;
CREATE TEMPORARY TABLE sessions_w_next_pageview_url
SELECT 
	swnpi.time_period,
    swnpi.website_session_id,
    wp.pageview_url AS next_pageview_url
FROM sessions_w_next_pageview_id swnpi
LEFT JOIN website_pageviews wp
	ON swnpi.website_session_id = wp.website_session_id;
    
-- STEP 4: summarize the data and analyze the pre vs.post periods
SELECT 
	time_period,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id END) AS w_next_page,
    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id END)/COUNT(DISTINCT website_session_id) AS pct_w_next_pageview,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_lovebear,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS to_lovebear
FROM sessions_w_next_pageview_url
GROUP BY 1    
    
    