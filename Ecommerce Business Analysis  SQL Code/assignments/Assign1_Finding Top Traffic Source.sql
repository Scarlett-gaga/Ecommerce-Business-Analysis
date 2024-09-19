-- understand where the website_sessions are coming from by breaking down by UTM source, campaign 
-- and referring domain, before 2019-04-12.

SELECT 
	DISTINCT utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY 1,2,3
ORDER BY 4 DESC
