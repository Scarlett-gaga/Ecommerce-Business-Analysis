-- we want to compare the bounce_rate for new home page(lander-1) and for the original one

-- STEP 1 : find the start date of using lander-1 (start at '2012-06-19')
SELECT 
	MIN(created_at) AS first_created_at,
	MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1' AND created_at IS NOT NULL;

-- STEP 2: find the mim pageview_id
CREATE TEMPORARY TABLE minpvs
SELECT 
	wp.website_session_id,
    MIN(wp.website_pageview_id) AS minpvs
FROM website_pageviews wp
	INNER JOIN website_sessions ws
		ON ws.website_session_id = wp.website_session_id
        AND ws.created_at < '2012-07-28'
        AND wp.website_pageview_id > 23504
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1;

-- STEP 3: match with url to see the landing page
CREATE TEMPORARY TABLE land
SELECT 
	m.website_session_id,
    wp.pageview_url AS landing_page
FROM minpvs m
	LEFT JOIN website_pageviews wp
		ON wp.website_pageview_id = m.minpvs
WHERE wp.pageview_url IN ('/home','/lander-1');
        
-- STEP 4: count pageviews for each session and limit it to just bounced session
CREATE TEMPORARY TABLE bounced_sessions
SELECT
	l.website_session_id,
	l.landing_page,
    COUNT(wp.website_pageview_id) AS count_of_pages_viewed
FROM land l
LEFT JOIN website_pageviews wp
	ON l.website_session_id = wp.website_session_id
GROUP BY 1,2
HAVING COUNT(wp.website_pageview_id) = 1;

-- STEP 5: create a table that summarize wether a session is bounced or not（这里很重要）
CREATE TEMPORARY TABLE bounced_nonbounced_summary
SELECT 
	l.landing_page,
    l.website_session_id,
    bs.website_session_id AS bounced_session_id
FROM land l   
LEFT JOIN bounced_sessions bs
	ON l.website_session_id = bs.website_session_id;

-- STEP 6: calculate bounce_rate
SELECT 
	landing_page,
	COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT bounced_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_session_id)/COUNT(DISTINCT website_session_id) AS bounce_rate
FROM bounced_nonbounced_summary
GROUP BY 1

	


