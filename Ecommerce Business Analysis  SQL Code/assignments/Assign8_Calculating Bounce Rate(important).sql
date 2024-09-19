-- we want to see the bounce rates for traffic landing on the home page


-- STEP 1: find the min pageview_id
DROP TEMPORARY TABLE landing;
CREATE TEMPORARY TABLE landing
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS minpvs
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY 1;

-- STEP 2: match the mim pageview_id with url to identify the landing page of each session
CREATE TEMPORARY TABLE sessions_w_landing_page
SELECT 
	l.website_session_id,
	wp.pageview_url AS landing_page
FROM landing l
LEFT JOIN website_pageviews wp
	ON wp.website_pageview_id = l.minpvs;

-- SELECT *  这一步连接很关键
-- FROM sessions_w_landing_page swlp
-- LEFT JOIN website_pageviews wp
-- ON swlp.website_session_id = wp.website_session_id;

-- STEP 3: counting the pageviews for each session and then restrict to only bounced session
CREATE TEMPORARY TABLE bounced_session    
SELECT 
	swlp.website_session_id,
    swlp.landing_page,
    COUNT(swlp.website_session_id) AS count_of_page_reviewed
FROM sessions_w_landing_page swlp
LEFT JOIN website_pageviews wp
	ON swlp.website_session_id = wp.website_session_id
GROUP BY 1,2
HAVING count_of_page_reviewed = 1; -- important, retrict to only bounced session

SELECT *
FROM bounced_session;


-- STEP 4: summarizing by counting total sessions and bounced sessions
CREATE TEMPORARY TABLE final
SELECT 
	swlp.website_session_id,
	bs.website_session_id AS bounced_session_id
FROM sessions_w_landing_page swlp
LEFT JOIN bounced_session bs
	ON swlp.website_session_id = bs.website_session_id;

SELECT 
	COUNT(DISTINCT website_session_id) AS total_sessions,
	COUNT(DISTINCT bounced_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_session_id)/ COUNT(DISTINCT website_session_id) AS bounce_rate
FROM final

    



    