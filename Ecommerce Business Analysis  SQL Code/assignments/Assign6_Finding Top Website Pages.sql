--  we want to see the most_viewed website page ranked by session volumne

SELECT 
	pageview_url,
    COUNT(website_session_id) AS sessions
FROM website_pageviews 
WHERE 
    created_at < '2012-06-09'
GROUP BY 1
ORDER BY sessions DESC;