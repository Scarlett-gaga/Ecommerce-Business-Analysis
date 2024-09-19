-- we want to see the weekly trend paid search nonbrad traffic landing on /home and /lander-1 with their weekly bounce rate since 06-01

-- STEP 1: find the first_website_pageview for each session
DROP TEMPORARY TABLE first_pageviews;
CREATE TEMPORARY TABLE first_pageviews
SELECT 
	ws.website_session_id,
	MIN(wp.website_pageview_id) AS first_pageview,
    COUNT(wp.website_pageview_id) AS count_pageviews
FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON wp.website_session_id = ws.website_session_id
WHERE 
	ws.utm_campaign = 'nonbrand' AND
    ws.utm_source = 'gsearch' AND
    ws.created_at > '2012-06-01' AND
    ws.created_at < '2012-08-31'
GROUP BY 1;


-- STEP 2: match the first_pageview_id with specific landing page url
CREATE TEMPORARY TABLE landing_page
SELECT
	fp.website_session_id,
    fp.first_pageview,
    fp.count_pageviews,
    wp.pageview_url AS landing_page,
	wp.created_at
FROM first_pageviews fp
LEFT JOIN website_pageviews wp
	ON fp.first_pageview = wp.website_pageview_id;
    

-- STEP 3: counting pageviews for each session to identify bounces, and summarizing by week(bounce rate, sessions to each lander)
SELECT 
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) AS bounced_session,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS  lander_session,
    COUNT(CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS  home_session
FROM landing_page lp
GROUP BY 
	YEAR(created_at),
    WEEK(created_at)
    





